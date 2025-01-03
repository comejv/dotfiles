{ config, pkgs, ... }:

{
  home.username = "comev";
  home.homeDirectory = "/home/comev";

  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ./dconf.nix
  ];

  home.packages = with pkgs; [
    chezmoi
    wl-clipboard
    fzf
    most
    btop
    discord
    nerd-fonts.jetbrains-mono
    git
    gcc
    gnumake
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "most";
  };

  home.file = {
      ".config/chezmoi/chezmoi.toml" = {
          text = ''[git]
              autoCommit = true
              autoPush = true
              '';
          executable = false;
      };
  };

  programs.neovim.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish; }
    ];
  };
}
