local api = vim.api
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- surround
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sc", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      config = {
        cpp = "// %s",
      },
    },
  },

  -- treesitter set dependencies
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "c",
        "cpp",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "vim",
        "yaml",
      },
    },
  },

  -- ai
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   config = function()
  --     vim.g.codeium_disable_bindings = 1
  --     vim.keymap.set("n", "<leader>ai", function()
  --       return vim.fn["CodeiumToggle"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-e>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-|>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-\\>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-x>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true })
  --     vim.g.codeium_filetypes = {
  --       sh = false,
  --       zsh = false,
  --     }
  --   end,
  -- },

  -- format
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        json = { "clang-format" },
        python = { "autopep8" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },

  {
    "Kurama622/style-transfer.nvim",
    cmd = { "TransferCamelCase", "TransferMixedCase", "TransferStrCase" },
    config = function()
      require("style_transfer").setup()
    end,
    keys = {
      { "crc", mode = "n", "<cmd>TransferCamelCase<cr>", desc = "namingStyle" },
      { "crm", mode = "n", "<cmd>TransferMixedCase<cr>", desc = "NamingStyle" },
      { "cr_", mode = "n", "<cmd>TransferStrCase _<cr>", desc = "naming_style" },
      { "cr-", mode = "n", "<cmd>TransferStrCase -<cr>", desc = "naming-style" },
      { "cr.", mode = "n", "<cmd>TransferStrCase .<cr>", desc = "naming.style" },
      { "cr ", mode = "n", "<cmd>TransferStrCase \\ <cr>", desc = "nameing style" },
      { "<leader>rc", mode = "x", "<cmd>TransferCamelCase<cr>", desc = "namingStyle" },
      { "<leader>rm", mode = "x", "<cmd>TransferMixedCase<cr>", desc = "NamingStyle" },
      { "<leader>r_", mode = "x", "<cmd>TransferStrCase _<cr>", desc = "naming_style" },
      { "<leader>r-", mode = "x", "<cmd>TransferStrCase -<cr>", desc = "naming-style" },
      { "<leader>r.", mode = "x", "<cmd>TransferStrCase .<cr>", desc = "naming.style" },
      { "<leader>r ", mode = "x", "<cmd>TransferStrCase \\ <cr>", desc = "naming style" },
    },
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    -- lazy = true,
    event = "BufRead",
    config = function()
      api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comments" })
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 100,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      })
    end,
    keys = {
      { "<leader>gg", mode = "n", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git Blame" },
    },
  },
}
