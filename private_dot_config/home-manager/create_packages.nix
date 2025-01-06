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
