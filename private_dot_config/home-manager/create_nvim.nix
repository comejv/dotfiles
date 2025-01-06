{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = true;
    extraPackages = with pkgs; [
      # LSP
      nixd
      shfmt
      clang-tools
      stylua

      # Highlight
      tree-sitter-grammars.tree-sitter-lua
      tree-sitter-grammars.tree-sitter-bash
      tree-sitter-grammars.tree-sitter-c
      tree-sitter-grammars.tree-sitter-vim
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-python
    ];
    extraPython3Packages = (
      pyPkgs: with pyPkgs; [
        python-lsp-server
        black
        isort
      ]
    );
  };
}
