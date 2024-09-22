require "nvchad.options"

-- add yours here!

local o = vim.o
o.relativenumber = true
o.tabstop = 4
o.shiftwidth = 4

local opt = vim.opt
opt.list = true

local enable_providers = {
  "python3_provider",
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end
