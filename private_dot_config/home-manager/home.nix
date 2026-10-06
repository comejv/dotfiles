{ config, pkgs, ... }:
{
  home.username = "comevinc";
  home.homeDirectory = "/home/comevinc";
  home.stateVersion = "26.05";
  nixpkgs.config = {
    allowUnfree = true;
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  # Handle systemd services on non-NixOS
  systemd.user.startServices = "sd-switch";

  imports = [
    #    ./dconf.nix # nix-shell -p dconf2nix --command """dconf dump / | dconf2nix > dconf.nix && mv dconf.nix .config/home-manager/"""
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./nvim.nix
    ./aliases.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
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
        date_bin="${pkgs.coreutils}/bin/date"
        sort_bin="${pkgs.coreutils}/bin/sort"
        count="$($task_bin rc.verbose=nothing status:pending due.before:2days count)"

        if [ "$count" -eq 0 ]; then
          exit 0
        fi

        today="$($date_bin +%F)"
        tomorrow="$($date_bin --date=tomorrow +%F)"
        noun="reminders"
        if [ "$count" -eq 1 ]; then
          noun="reminder"
        fi

        escape_markup() {
          sed -e 's/&/\&amp;/g' \
            -e 's/</\&lt;/g' \
            -e 's/>/\&gt;/g' \
            -e 's/"/\&quot;/g'
        }

        markup="<span size='x-large' weight='bold'>$count $noun coming up</span>"
        first_task=1

        while IFS=' ' read -r due_raw uuid; do
            description="$($task_bin rc.verbose=nothing _get "$uuid.description")"
            due_date="$(printf '%.10s' "$due_raw")"
            due_display="$($date_bin --date="$due_date" '+%A %-d %B')"

            if [[ "$due_date" < "$today" ]]; then
              due_label="OVERDUE · $due_display"
              due_color="#c01c28"
            elif [ "$due_date" = "$today" ]; then
              due_label="TODAY · $due_display"
              due_color="#c64600"
            elif [ "$due_date" = "$tomorrow" ]; then
              due_label="TOMORROW · $due_display"
              due_color="#1c71d8"
            else
              due_label="$due_display"
              due_color="#5e5c64"
            fi

            escaped_description="$(printf '%s' "$description" | escape_markup)"
            escaped_due_label="$(printf '%s' "$due_label" | escape_markup)"

            if [ "$first_task" -eq 0 ]; then
              markup="$markup

        <span foreground='#c0bfbc'>────────────────────────────────────</span>"
            fi
            first_task=0

            markup="$markup

        <span foreground='$due_color' weight='bold'>$escaped_due_label</span>
        <span size='large' weight='bold'>$escaped_description</span>"

            annotation_count="$($task_bin rc.verbose=nothing _get "$uuid.annotations.count")"
            if [ -z "$annotation_count" ]; then
              annotation_count=0
            fi

            annotation_index=1
            while [ "$annotation_index" -le "$annotation_count" ]; do
              annotation="$($task_bin rc.verbose=nothing \
                _get "$uuid.annotations.$annotation_index.description")"

              markup="$markup
        <span foreground='#5e5c64' size='small'>LINKS &amp; NOTES</span>"

              while IFS= read -r item; do
                if [[ "$item" =~ ^([^:]+):[[:space:]]+(https?://.*)$ ]]; then
                  link_label="''${BASH_REMATCH[1]}"
                  link_url="''${BASH_REMATCH[2]}"
                  escaped_label="$(printf '%s' "$link_label" | escape_markup)"
                  escaped_url="$(printf '%s' "$link_url" | escape_markup)"
                  markup="$markup
        <a href='$escaped_url'>$escaped_label ↗</a>"
                else
                  escaped_item="$(printf '%s' "$item" | escape_markup)"
                  markup="$markup
        <span foreground='#5e5c64'>$escaped_item</span>"
                fi
              done < <(printf '%s\n' "$annotation" | sed 's/ | /\n/g')

              annotation_index=$((annotation_index + 1))
            done
        done < <(
          for uuid in $($task_bin rc.verbose=nothing \
            status:pending due.before:2days uuids); do
            due_raw="$($task_bin rc.verbose=nothing _get "$uuid.due")"
            printf '%s %s\n' "$due_raw" "$uuid"
          done | "$sort_bin"
        )

        "$zenity_bin" --info \
          --title="Task reminders" \
          --icon="appointment-soon-symbolic" \
          --text="$markup" \
          --ok-label="Close" \
          --width=720 || true
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
}
