{ config, pkgs, ... }:

{
  home.username = "comev";
  home.homeDirectory = "/home/comev";

  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  imports = [
    ./dconf.nix
  ];

  home.packages = with pkgs; [
    chezmoi
	wl-clipboard
	tlp
	keyd
    fzf
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
