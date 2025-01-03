{ config, pkgs, ... }:

{
  home.username = "comev";
  home.homeDirectory = "/home/comev";

  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    chezmoi
	wl-clipboard
	tlp
	keyd
    most
    btop
    discord
	nerd-fonts.jetbrains-mono
	git
	gcc
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
