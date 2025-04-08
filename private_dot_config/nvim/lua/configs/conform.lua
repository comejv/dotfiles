local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    c = { "clang-format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    ocaml = { "ocamlformat" },
    nix = { "nixfmt-rfc-style" },
    latex = { "tex-fmt" },
    python = { "black" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
