local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    c = { "clang-format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    ocaml = { "ocaml-format" },
    nix = { "nixfmt-rfc-style" },
    latex = { "tex-fmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
