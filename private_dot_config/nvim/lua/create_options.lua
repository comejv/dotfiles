require "nvchad.options"

local o = vim.o
o.relativenumber = true
o.tabstop = 4
o.shiftwidth = 4
o.shell = "/home/comev/.nix-profile/bin/fish"

local opt = vim.opt
opt.list = true
