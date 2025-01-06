{ ... }:

{
  home.username = "comev";
  home.homeDirectory = "/home/comev";
  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  imports = [
    ./dconf.nix
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./nvim.nix
    ./aliases.nix
  ];

  home.sessionVariables = {
    PAGER = "most";
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
  };
}
