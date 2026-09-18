{ config, pkgs, ... }:
let
  nixgl-overlay = final: prev: {
    nixgl = (
      import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") {
        # Pass the final package set to the nixGL build
        pkgs = final;
      }
    );
  };

  toggle-theme-script = pkgs.writeShellScriptBin "toggle-theme" ''
    # Robustly find DBUS_SESSION_BUS_ADDRESS if not set
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    fi

    # Use system-native gsettings to ensure it talks to the right dconf session
    GSETTINGS="/usr/bin/gsettings"
    if [ ! -f "$GSETTINGS" ]; then
        GSETTINGS="${pkgs.glib}/bin/gsettings"
    fi

    set_theme() {
        local mode=$1
        if [ "$mode" = "light" ]; then
            echo "Setting light mode..."
            $GSETTINGS set org.gnome.desktop.interface color-scheme 'prefer-light'
        else
            echo "Setting dark mode..."
            $GSETTINGS set org.gnome.desktop.interface color-scheme 'prefer-dark'
        fi
    }

    toggle_theme() {
        # Get value and strip single quotes
        current=$($GSETTINGS get org.gnome.desktop.interface color-scheme | tr -d "'")
        if [ "$current" = "prefer-dark" ]; then
            set_theme "light"
        else
            set_theme "dark"
        fi
    }

    ACTION=''${1:-toggle}

    case "$ACTION" in
        light)
            set_theme "light"
            ;;
        dark)
            set_theme "dark"
            ;;
        toggle)
            toggle_theme
            ;;
        auto)
            # Time based auto behavior
            hour=$(date +%H)
            if [ "$hour" -ge 8 ] && [ "$hour" -lt 18 ]; then
                set_theme "light"
            else
                set_theme "dark"
            fi
            ;;
        *)
            echo "Usage: toggle-theme [light|dark|toggle|auto]"
            exit 1
            ;;
    esac
  '';
in
{
  home.username = "comev";
  home.homeDirectory = "/home/comev";
  home.stateVersion = "26.05";
  nixpkgs.config = {
    allowUnfree = true;
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  # Handle systemd services on non-NixOS
  systemd.user.startServices = "sd-switch";

  nixpkgs.overlays = [ nixgl-overlay ];
  imports = [
    #    ./dconf.nix # nix-shell -p dconf2nix --command """dconf dump / | dconf2nix > dconf.nix && mv dconf.nix .config/home-manager/"""
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./nvim.nix
    ./aliases.nix
    ./kitty.nix
  ];

  home.packages = [
    toggle-theme-script
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERMINAL = "kitty";
    PAGER = "less -FR";
  };

  home.file = {
    ".taskrc".text = ''
      data.location=~/.task
    '';
    ".local/bin/task-reminders" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        task_bin="${pkgs.taskwarrior3}/bin/task"
        zenity_bin="${pkgs.zenity}/bin/zenity"
        count="$($task_bin rc.verbose=nothing status:pending due.before:tomorrow count)"

        if [ "$count" -eq 0 ]; then
          exit 0
        fi

        tasks="$($task_bin rc.verbose=nothing rc.color=off \
          rc.report.next.columns=description,due \
          rc.report.next.labels=Task,Due \
          status:pending due.before:tomorrow next)"
        escaped_tasks="$(printf '%s' "$tasks" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')"

        "$zenity_bin" --warning \
          --title="Task reminders" \
          --text="<span font_desc='Sans 15'>$escaped_tasks</span>" \
          --width=700
      '';
      executable = true;
    };
    ".config/chezmoi/chezmoi.toml" = {
      text = ''
        [git]
                  autoCommit = true
                  autoPush = true
      '';
      executable = false;
    };
    ".config/fontconfig/conf.d/10-nix-fonts.conf".text = ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
        <dir>~/.nix-profile/share/fonts/</dir>
      </fontconfig>
    '';
  };

  xdg.desktopEntries = {
    kitty = {
      name = "kitty";
      genericName = "Terminal emulator";
      comment = "Fast, feature-rich, GPU based terminal emulator";
      exec = "nixGL kitty";
      icon = "kitty";
      categories = [ "System" "TerminalEmulator" ];
    };
    btop = {
      name = "btop";
      genericName = "System Monitor";
      comment = "Resource monitor that shows usage and stats";
      exec = "nixGL kitty -1 btop";
      icon = "btop";
      terminal = false;
      categories = [ "System" "Monitor" ];
    };
  };

  systemd.user.services.task-reminders = {
    Unit = { Description = "Show due Taskwarrior tasks in a WSLg popup"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/task-reminders";
      Environment = [
        "DISPLAY=:0"
        "WAYLAND_DISPLAY=wayland-0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  systemd.user.timers.task-reminders = {
    Unit = { Description = "Check Taskwarrior reminders every morning"; };
    Timer = {
      OnCalendar = "*-*-* 09:00:00";
      Persistent = true;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  # Automatic Theme Switching (8am Light, 6pm Dark)
  systemd.user.services.toggle-theme = {
    Unit = {
      Description = "Switch between light and dark themes";
    };
    Service = {
      Type = "oneshot";
      # Use 'auto' action for the systemd timer
      ExecStart = "${toggle-theme-script}/bin/toggle-theme auto";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.toggle-theme = {
    Unit = { Description = "Automatic theme switching timer"; };
    Timer = {
      OnCalendar = [ "08:00:00" "18:00:00" ];
      Persistent = true;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
