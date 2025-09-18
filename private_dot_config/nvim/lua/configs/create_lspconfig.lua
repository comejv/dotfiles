local lspconfig = require "lspconfig"

-- Helper function to check if an LSP server executable is available
local function is_executable(name)
  return vim.fn.executable(name) == 1
end

-- Check and set up `clangd`
if is_executable "clangd" then
  lspconfig.clangd.setup {}
end

-- Check and set up `cmake`
if is_executable "cmake-language-server" then
  lspconfig.cmake.setup {}
end

-- Check and set up `pylsp`
if is_executable "pylsp" then
  lspconfig.pylsp.setup {}
end

-- Check and set up `texlab`
if is_executable "texlab" then
  lspconfig.texlab.setup {
    settings = {
      texlab = {
        build = {
          onSave = true,
        },
      },
    },
  }
end

-- Check and set up `ocamllsp`
if is_executable "ocamllsp" then
  lspconfig.ocamllsp.setup {}
end

-- Check and set up `nixd`
if is_executable "nixd" then
  lspconfig.nixd.setup {}
end

if is_executable "lua-language-server" then
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

-- markdown
require("render-markdown").setup {
  completions = { lsp = { enabled = true } },
}

-- Rust (via rust-analyzer)
if is_executable "rust-analyzer" then
  lspconfig.rust_analyzer.setup {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        procMacro = { enable = true },
        inlayHints = {
          enable = true,
          parameterHints = { enable = true },
          typeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true },
          lifetimeElisionHints = { enable = "skip_trivial" }, -- "always" | "never" | "skip_trivial"
          reborrowHints = { enable = "always" },
          renderColons = true,
          maxLength = 50,
        },
      },
    },
    on_attach = function(client, bufnr)
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
  }
end
