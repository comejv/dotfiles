local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    ocaml = { "ocamlformat" },
    nix = { "nixfmt-rfc-style" },
    latex = { "tex-fmt" },
    python = { "black" },
    tex = { "tex-fmt" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
