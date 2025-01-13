local lspconfig = require "lspconfig"

-- Helper function to check if an LSP server executable is available
local function is_executable(name)
  return vim.fn.executable(name) == 1
end

-- Check and set up `clangd`
if is_executable("clangd") then
  lspconfig.clangd.setup {}
end

-- Check and set up `pylsp`
if is_executable("pylsp") then
  lspconfig.pylsp.setup {}
end

-- Check and set up `cmake`
if is_executable("cmake-language-server") then
  lspconfig.cmake.setup {}
end

-- Check and set up `texlab`
if is_executable("texlab") then
  lspconfig.texlab.setup {}
end

-- Check and set up `ocamllsp`
if is_executable("ocamllsp") then
  lspconfig.ocamllsp.setup {}
end

-- Check and set up `nixd`
if is_executable("nixd") then
  lspconfig.nixd.setup {}
end
