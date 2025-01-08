local lspconfig = require "lspconfig"

lspconfig.clangd.setup {}

lspconfig.pylsp.setup {}

lspconfig.cmake.setup {}

lspconfig.texlab.setup {}

-- Check if `ocamllsp` is available in the environment
local has_ocamllsp = vim.fn.executable "ocamllsp" == 1

if has_ocamllsp then
  -- Set up ocamllsp only if it's available
  lspconfig.ocamllsp.setup {}
end

lspconfig.nixd.setup {}
