{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      # LSP
      nixd
      shfmt
      clang-tools
      stylua

      # Highlight
      tree-sitter
      nodejs
      vimPlugins.nvim-treesitter-parsers.lua
      vimPlugins.nvim-treesitter-parsers.bash
      vimPlugins.nvim-treesitter-parsers.c
      vimPlugins.nvim-treesitter-parsers.cpp
      vimPlugins.nvim-treesitter-parsers.vim
      vimPlugins.nvim-treesitter-parsers.markdown
      vimPlugins.nvim-treesitter-parsers.python

      # Images
      imagemagick
    ];
  };
}
