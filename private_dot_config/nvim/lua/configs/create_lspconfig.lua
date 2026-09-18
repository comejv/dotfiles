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

-- clangd
vim.lsp.config("clangd", {
  on_attach = on_attach,
})
vim.lsp.enable "clangd"

-- cmake
vim.lsp.config("cmake", {
  on_attach = on_attach,
})
vim.lsp.enable "cmake"

-- pyright
vim.lsp.config("pyright", {
  on_attach = on_attach,
})
vim.lsp.enable "pyright"

-- texlab
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

-- ocamllsp
vim.lsp.config("ocamllsp", {
  on_attach = on_attach,
})
vim.lsp.enable "ocamllsp"

-- nixd
vim.lsp.config("nixd", {
  on_attach = on_attach,
})
vim.lsp.enable "nixd"

-- rust-analyzer
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

-- tsserver
vim.lsp.config("tsserver", {
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayparameterNames = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})
vim.lsp.enable "tsserver"

-- tailwindcss (for Tailwind CSS autocompletion and linting)
-- This uses the 'tailwindcss-language-server' you added.
vim.lsp.config("tailwindcss", {
  on_attach = on_attach,
  filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "svelte" },
  settings = {
    tailwindCSS = {},
  },
})
vim.lsp.enable "tailwindcss"

-- html (for HTML language features)
-- Provided by 'vscode-langservers-extracted'.
vim.lsp.config("html", {
  on_attach = on_attach,
})
vim.lsp.enable "html"

-- cssls (for CSS language features)
-- Provided by 'vscode-langservers-extracted'.
vim.lsp.config("cssls", {
  on_attach = on_attach,
})
vim.lsp.enable "cssls"

-- jsonls (for JSON language features)
-- Provided by 'vscode-langservers-extracted'.
vim.lsp.config("jsonls", {
  on_attach = on_attach,
})
vim.lsp.enable "jsonls"

-- julials
-- get the server path by running:
-- julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
-- julia -e 'print(Base.find_package("LanguageServer"))'
local server_path = "/home/comev/Documents/verifnn/.julia/packages/LanguageServer/Fwm1f"
vim.lsp.config("julials", {
  on_attach = on_attach,

  on_new_config = function(new_config, _)
    local server_path = server_path

    new_config.cmd = {
      "julia",
      "--project=" .. server_path,
      "--startup-file=no",
      "--history-file=no",
      "-e",
      [[
        using Pkg
        Pkg.instantiate()
        using LanguageServer

        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
        project_path = let
          dirname(something(
            Base.load_path_expand((
              p = get(ENV, "JULIA_PROJECT", nothing);
              p === nothing ? nothing : isempty(p) ? nothing : p
            )),
            Base.current_project(),
            get(Base.load_path(), 1, nothing),
            Base.load_path_expand("@v#.#"),
          ))
        end

        @info "Running Julia Language Server" VERSION pwd() project_path depot_path

        server = LanguageServer.LanguageServerInstance(
          stdin,
          stdout,
          project_path,
          depot_path
        )
        server.runlinter = true
        run(server)
      ]],
    }
  end,
})
vim.lsp.enable "julials"
