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
    gcc
    gnumake
    ripgrep
    nixfmt-rfc-style
  ];

  home.sessionVariables = {
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

  programs.git.enable = true;

  programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
  };

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
