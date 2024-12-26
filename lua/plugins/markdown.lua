return {
  -- markdown
  {
    "dhruvasagar/vim-table-mode",
    cmd = { "TableModeToggle", "TableModeRealign" },
    on_filetype = "markdown",
    keys = {
      { "<leader>tm", mode = "n", "<cmd>TableModeToggle<cr>", desc = "table mode toggle" },
      { "<leader>tr", mode = "n", "<cmd>TableModeRealign<cr>", desc = "table mode realign" },
    },
  },

  {
    "Kurama622/markdown-org",
    ft = "markdown",
    config = function()
      return {
        default_quick_keys = 0,
        vim.api.nvim_set_var("org#style#border", 2),
        vim.api.nvim_set_var("org#style#bordercolor", "FloatBorder"),
        vim.api.nvim_set_var("org#style#color", "String"),
        language_path = {
          python = "python",
          python3 = "python3",
          go = "go",
          c = "gcc",
          cpp = "g++",
        },
      }
    end,
    keys = {
      { "<leader>mb", "<cmd>call org#main#runCodeBlock()<cr>", desc = "run code block" },
      { "<leader>ml", "<cmd>call org#main#runLanguage()<cr>", desc = "run language" },
    },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown", -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Your configuration here (optional)
    },
    -- config = function()
    --   require("mtoc").setup({})
    -- end,
    keys = {
      { "<leader>mt", "<cmd>Mtoc<cr>", desc = "gen markdown toc" },
    },
  },
  {
    "Kurama622/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      dash = {
        -- Turn on / off thematic break rendering
        enabled = true,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
        icon = "─",
        width = 0.5,
        left_margin = 0.5,
        -- Highlight for the whole line generated from the icon
        highlight = "RenderMarkdownDash",
      },
    },
  },
}
