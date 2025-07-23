{ pkgs, ... }:

{
  home.username = "vincec4";
  home.homeDirectory = "/home/vincec4";
  home.stateVersion = "24.11";
  nixpkgs.config = {
    allowUnfree = true;
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

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
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
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
}
