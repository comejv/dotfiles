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
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gdiff", "Gcommit", "Gpush", "Gpull" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
      { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add current file" },
      { "<leader>gA", "<cmd>Git add .<cr>", desc = "Git add all files" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git diff current file" },
      { "<leader>gD", "<cmd>Git diff<cr>", desc = "Git diff all files" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<C-Right>",
          clear_suggestion = "<C-Left>",
          accept_word = "<C-S-Right>",
        },
        disable_keymaps = false,
      }
    end,
    lazy = false,
  
  },
}
