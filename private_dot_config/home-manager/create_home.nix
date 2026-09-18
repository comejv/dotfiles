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
