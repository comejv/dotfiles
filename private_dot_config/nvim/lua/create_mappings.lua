require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp", size = 0.4 } -- changed to 40%
end, { desc = "Terminal New horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp", size = 0.3 }
end, { desc = "Terminal New vertical window" })

map("n", "<leader>e", vim.diagnostic.open_float)

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})
