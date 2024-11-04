-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "bearded-arc",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

vim.cmd("autocmd BufNewFile,BufRead *.lus set filetype=lustre")
vim.cmd("autocmd BufNewFile,BufRead *.ys set filetype=y86")
vim.cmd("autocmd BufNewFile,BufRead *.hcl set filetype=hcl")


return M
