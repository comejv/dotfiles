{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Keep the NvChad configuration at ~/.config/nvim/init.lua unmanaged.
    # Home Manager loads its generated provider setup through the wrapper.
    sideloadInitLua = true;
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

      tex-fmt
    ];
  };
}
