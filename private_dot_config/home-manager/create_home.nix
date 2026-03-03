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
in
{
  home.username = "comev";
  home.homeDirectory = "/home/comev";
  home.stateVersion = "25.11";
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
    ".local/share/applications/kitty.desktop" = {
      text =
        let
          originalDesktopFile = builtins.readFile "${pkgs.kitty}/share/applications/kitty.desktop";
        in
        builtins.replaceStrings
          [
            "TryExec=kitty"
            "Exec=kitty"
          ]
          [
            ""
            "Exec=nixGL kitty"
          ]
          originalDesktopFile;
      force = true;
    };

    # Example for btop.desktop
    ".local/share/applications/btop.desktop" = {
      text =
        let
          originalDesktopFile = builtins.readFile "${pkgs.btop}/share/applications/btop.desktop";
        in
        builtins.replaceStrings
          [ "Exec=btop" "Terminal=true" ]
          [ "Exec=nixGL kitty -1 btop" "Terminal=false" ]
          originalDesktopFile;
      force = true;
    };
  };

  # Automatic Theme Switching (8am Light, 6pm Dark)
  systemd.user.services.toggle-theme = {
    Unit = {
      Description = "Switch between light and dark themes";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.config/home-manager/scripts/toggle-theme.sh";
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
