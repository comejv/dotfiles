local function is_executable(name)
  return vim.fn.executable(name) == 1
end

-- Shared on_attach to handle inlay hints
local function on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    local ok_new = pcall(function()
      vim.lsp.inlay_hint(bufnr, true)
    end)
    if not ok_new then
      pcall(function()
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end)
    end
  end
end

-- Lua LS
if is_executable "lua-language-server" then
  vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })
  vim.lsp.enable "lua_ls"
end

-- clangd
if is_executable "clangd" then
  vim.lsp.config("clangd", {
    on_attach = on_attach,
  })
  vim.lsp.enable "clangd"
end

-- cmake
if is_executable "cmake-language-server" then
  vim.lsp.config("cmake", {
    on_attach = on_attach,
  })
  vim.lsp.enable "cmake"
end

-- pylsp
if is_executable "pylsp" then
  vim.lsp.config("pylsp", {
    on_attach = on_attach,
  })
  vim.lsp.enable "pylsp"
end

-- texlab
if is_executable "texlab" then
  vim.lsp.config("texlab", {
    on_attach = on_attach,
    settings = {
      texlab = {
        build = {
          onSave = true,
        },
      },
    },
  })
  vim.lsp.enable "texlab"
end

-- ocamllsp
if is_executable "ocamllsp" then
  vim.lsp.config("ocamllsp", {
    on_attach = on_attach,
  })
  vim.lsp.enable "ocamllsp"
end

-- nixd
if is_executable "nixd" then
  vim.lsp.config("nixd", {
    on_attach = on_attach,
  })
  vim.lsp.enable "nixd"
end

-- rust-analyzer
if is_executable "rust-analyzer" then
  vim.lsp.config("rust_analyzer", {
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          buildScripts = { enable = true },
        },
        procMacro = { enable = true },
        inlayHints = {
          enable = true,
          parameterHints = {
            enable = false,
          },
          typeHints = {
            enable = true,
            hideFormatString = true,
            hideClosureInitialization = false,
            hideAwait = true,
            maxLength = 50,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 10,
          },
          lifetimeElisionHints = {
            enable = "skip_trivial",
          },
          reborrowHints = {
            enable = "always",
          },
          renderColons = true,
          maxLength = 80,
          discriminantHints = {
            enable = false,
          },
        },
        check = {
          command = "clippy",
          allTargets = true,
        },
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
      },
    },
  })
  vim.lsp.enable "rust_analyzer"
end
