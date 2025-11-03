local api, g = vim.api, vim.g
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
      g.language_path = {
        python = "python",
        python3 = "python3",
        go = "go",
        c = "gcc -Wall",
        cpp = "g++ -std=c++11 -Wall",
        ["c++"] = "g++ -std=c++11 -Wall",
        bash = "bash",
      }
      return {
        default_quick_keys = 0,
        api.nvim_set_var("org#style#border", 2),
        api.nvim_set_var("org#style#bordercolor", "FloatBorder"),
        api.nvim_set_var("org#style#color", "String"),
        api.nvim_set_var("org_output_to_clipboard", 0),
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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        opts = {
          -- A list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "html", "markdown", "markdown_inline", "python" },
        },
        config = function(_, opts)
          local TS = require("nvim-treesitter")
          TS.setup(opts)
          local parser = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(TS.get_installed(), lang)
          end, opts.ensure_installed)
          if #parser > 0 then
            vim.schedule(function()
              TS.install(parser)
            end)
          end
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "llm", "markdown" },
            callback = function()
              vim.treesitter.start(0, "markdown")
            end,
          })
        end,
      },
      "nvim-mini/mini.icons",
    }, -- if you use standalone mini plugins
    ft = { "markdown", "llm" },

    config = function()
      api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "#4fd6be", bg = "NONE" })
      api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
      require("render-markdown").setup({
        restart_highlighter = true,
        heading = {
          enabled = true,
          sign = false,
          position = "overlay", -- inline | overlay
          icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
          signs = { "󰫎 " },
          width = "block",
          left_margin = 0,
          left_pad = 0,
          right_pad = 0,
          min_width = 0,
          border = false,
          border_virtual = false,
          border_prefix = false,
          above = "▄",
          below = "▀",
          backgrounds = {},
          foregrounds = {
            "RenderMarkdownH1",
            "RenderMarkdownH2",
            "RenderMarkdownH3",
            "RenderMarkdownH4",
            "RenderMarkdownH5",
            "RenderMarkdownH6",
          },
        },
        bullet = { highlight = "String" },
        dash = {
          enabled = true,
          icon = "─",
          width = 0.5,
          left_margin = 0.5,
          highlight = "RenderMarkdownDash",
        },
        code = { style = "normal" },
      })
    end,
  },
}
