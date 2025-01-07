{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Utilities
    chezmoi
    wl-clipboard
    most
    btop
    fd
    fzf
    ripgrep
    (import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") {}).auto.nixGLDefault

    # Comm
    discord

    # SE
    gcc
    gnumake

    # Nix
    nixfmt-rfc-style
    nix-your-shell
  ];
}
