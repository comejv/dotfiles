{ config, pkgs, ... }:

{
  home.username = "comev";
  home.homeDirectory = "/home/comev";

  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ./dconf.nix   # to generate : nix-shell -p dconf2nix --command """dconf dump / | dconf2nix > dconf.nix && mv dconf.nix .config/home-manager/"""
  ];

  home.packages = with pkgs; [
    chezmoi
    wl-clipboard
    most
    btop
    discord
    nerd-fonts.jetbrains-mono
    gcc
    gnumake
    ripgrep
    nixfmt-rfc-style
    nix-your-shell
    fd
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
  programs.dircolors = {
      enable = true;
      enableFishIntegration = true;
  };

  programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withRuby = false;
  };

  programs.fzf = {
      enable = true;
      enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      if command -q nix-your-shell
        nix-your-shell fish | source
      end'';
    plugins = [
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
    ];
    functions = {
        multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
    };
    shellAbbrs = {
        dotdot = {
            regex = ''^\.\.+$'';
            function = ''multicd'';
        };
    };
  };
}
