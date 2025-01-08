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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.tex",
      callback = function()
        vim.fn.system "latexmk"
        vim.fn.system "xdg-open build/main.pdf"
      end,
    })
  end,
})

return M
