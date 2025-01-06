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
    python312Packages.python-lsp-server
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

  home.shellAliases = {
      py = "python3";
      ll = "ls -l";
      la = "ls -a";
      l = "ls -CF";
      gdb = "gdb -tui";
      xfs = "sshfs_x";
      icat = "kitten icat";
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
        sshfs_x = ''
          if test (count $argv) -gt 0
              set pc $argv[1]
          else
              set pc porsche
          end
          sudo sshfs -oallow_other "$pc.p:/users/eleves-b/2024/come.vincent" /mnt/X/ -F /home/comev/.ssh/config
        '';
    };
    shellAbbrs = {
        dotdot = {
            regex = ''^\.\.+$'';
            function = ''multicd'';
        };
    };
  };
}
