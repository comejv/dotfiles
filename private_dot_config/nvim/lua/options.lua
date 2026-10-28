require "nvchad.options"

local o = vim.o
o.relativenumber = true
if vim.env.HOME then
  o.shell = vim.env.HOME .. "/.nix-profile/bin/fish"
else
  vim.notify("HOME environment variable is not set", vim.log.levels.ERROR)
end

local opt = vim.opt
opt.list = true

-- Opam config for ocaml
local opamshare = vim.fn.trim(vim.fn.system "opam var share 2>/dev/null")
if opamshare == "" then
  vim.notify("Could not retrieve opam share directory. Please check your opam installation.", vim.log.levels.WARN)
else
  local merlinPath = opamshare .. "/merlin/vim"
  opt.rtp:append(merlinPath)
end
