return {
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufNewFile", "BufReadPost" },
    opts = { mode = "topline", max_lines = 5 },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
    event = { "BufNewFile", "BufReadPost" },
  },
}
