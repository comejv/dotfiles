return {
  {
    "williamboman/mason.nvim",
    automatic_installation = true,
  },
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
      ensure_installed = {
        "vim",
        "lua",
        "c",
        "bash",
        "markdown",
        "printf",
        "python",
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
