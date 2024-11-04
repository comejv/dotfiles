require "nvchad.mappings"

-- add yours here

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
