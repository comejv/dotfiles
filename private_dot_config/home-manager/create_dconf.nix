# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "secret-service:///org/freedesktop/secrets/collection/login" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 600;
    };

    "desktop/ibus/general" = {
      version = "1.5.27";
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [
        960
        600
      ];
    };

    "org/gnome/control-center" = {
      last-panel = "keyboard";
      window-state = mkTuple [
        1103
        835
        false
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "Utilities"
        "YaST"
      ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "gnome-abrt.desktop"
        "gnome-system-log.desktop"
        "nm-connection-editor.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.DejaDup.desktop"
        "org.gnome.Dictionary.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.eog.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.fonts.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.tweaks.desktop"
        "org.gnome.Usage.desktop"
        "vinagre.desktop"
      ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      current = mkUint32 0;
      sources = [
        (mkTuple [
          "xkb"
          "fr+oss"
        ])
      ];
      xkb-options = [ ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      monospace-font-name = "JetBrainsMono Nerd Font 11";
      show-battery-percentage = true;
      text-scaling-factor = 1.25;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [
        "org-gnome-software"
        "org-gnome-nautilus"
        "org-gnome-settings"
        "gnome-network-panel"
        "vivaldi-stable"
      ];
    };

    "org/gnome/desktop/notifications/application/discord" = {
      application-id = "discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox-esr" = {
      application-id = "firefox-esr.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/kitty" = {
      application-id = "kitty.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-evince" = {
      application-id = "org.gnome.Evince.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/notifications/application/vivaldi-stable" = {
      application-id = "vivaldi-stable.desktop";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      speed = 0.351598;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      report-technical-problems = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/evince/default" = {
      window-ratio = mkTuple [
        1.3970588235294117
        1.3775252525252526
      ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/evolution" = {
      version = "3.46.4";
    };

    "org/gnome/evolution/addressbook" = {
      completion-minimum-query-length = 3;
      completion-show-address = false;
    };

    "org/gnome/evolution/calendar" = {
      use-24hour-format = true;
      week-start-day-name = "monday";
      work-day-friday = true;
      work-day-monday = true;
      work-day-saturday = false;
      work-day-sunday = false;
      work-day-thursday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
    };

    "org/gnome/evolution/mail" = {
      browser-close-on-reply-policy = "ask";
      composer-visually-wrap-long-lines = false;
      forward-style-name = "attached";
      image-loading-policy = "never";
      reply-style-name = "quoted";
    };

    "org/gnome/evolution/mail/composer-window" = {
      height = 500;
      maximized = false;
      width = 708;
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [
        890
        550
      ];
    };

    "org/gnome/nm-applet/eap/7ab52d8e-a29b-4f62-a927-58a59f606092" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "nixGL kitty";
      name = "kitty";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "gestureImprovements@gestures"
        "clipboard-indicator@tudmotu.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "vivaldi-stable.desktop"
        "libreoffice-writer.desktop"
      ];
      welcome-dialog-last-shown-version = "43.9";
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = [ "<Control><Alt>v" ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = [ ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [ ];
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1736166796;
      first-run = false;
      install-timestamp = mkInt64 1739635216;
      online-updates-timestamp = mkInt64 1739635186;
      update-notification-timestamp = mkInt64 1735853210;
    };

    "org/gnome/system/location" = {
      enabled = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 140;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [
        1069
        374
      ];
    };

    "org/gtk/settings/color-chooser" = {
      selected-color = mkTuple [
        true
        0.0
        0.0
        0.0
        1.0
      ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 233;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [
        26
        23
      ];
      window-size = mkTuple [
        1863
        1113
      ];
    };

    "system/proxy" = {
      mode = "none";
    };

  };
}
