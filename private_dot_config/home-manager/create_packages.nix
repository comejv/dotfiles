{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Utilities
    chezmoi
    wl-clipboard
    most
    btop
    fd
    ripgrep

    # Comm
    discord

    # SE
    nerd-fonts.jetbrains-mono
    gcc
    gnumake

    # Nix
    nixfmt-rfc-style
    nix-your-shell
  ];
}
