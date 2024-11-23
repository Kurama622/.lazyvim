return {

  -- surround
  {
    "echasnovski/mini.surround",
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

  -- run code
  {
    "Kurama622/FloatRun",
    cmd = { "FloatRunToggle", "FloatTermToggle" },
    opts = function()
      return {
        ui = {
          border = "rounded",
          float_hl = "Normal",
          border_hl = "FloatBorder",
          blend = 0,
          height = 0.5,
          width = 0.7,
          x = 0.5,
          y = 0.5,
        },
        run_command = {
          cpp = "g++ -std=c++11 %s -Wall -o {} && {}",
          python = "python %s",
          lua = "lua %s",
          sh = "bash %s",
          Zsh = "bash %s",
          [""] = "",
        },
      }
    end,
    keys = {
      { "<F5>", "<cmd>FloatRunToggle<cr>" },
      { "<F2>", mode = { "n", "t" }, "<cmd>FloatTermToggle<cr>" },
    },
  },

  -- ai
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      vim.keymap.set("n", "<leader>ai", function()
        return vim.fn["CodeiumToggle"]()
      end, { expr = true })
      vim.keymap.set("i", "<c-e>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
      vim.keymap.set("i", "<c-|>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true })
      vim.keymap.set("i", "<c-\\>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true })
      vim.g.codeium_filetypes = {
        sh = false,
        zsh = false,
      }
    end,
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- inlay_hints = { enabled = vim.fn.has("nvim-0.10") },
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        clangd = {},
        pyright = {},
      },
    },
  },

  -- format
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "autopep8" },
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
      { "crc", mode = "n", "<cmd>TransferCamelCase<cr>" },
      { "crm", mode = "n", "<cmd>TransferMixedCase<cr>" },
      { "cr_", mode = "n", "<cmd>TransferStrCase _<cr>" },
      { "cr-", mode = "n", "<cmd>TransferStrCase -<cr>" },
      { "cr.", mode = "n", "<cmd>TransferStrCase .<cr>" },
      { "cr ", mode = "n", "<cmd>TransferStrCase \\ <cr>" },
      { "rc", mode = "x", "<cmd>TransferCamelCase<cr>" },
      { "rm", mode = "x", "<cmd>TransferMixedCase<cr>" },
      { "r_", mode = "x", "<cmd>TransferStrCase _<cr>" },
      { "r-", mode = "x", "<cmd>TransferStrCase -<cr>" },
      { "r.", mode = "x", "<cmd>TransferStrCase .<cr>" },
    },
  },

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
    -- opts = {
    --   -- Your configuration here (optional)
    -- },
    config = function()
      require("mtoc").setup({})
    end,
    keys = {
      { "<leader>mt", "<cmd>Mtoc<cr>", desc = "gen markdown toc" },
    },
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    -- lazy = true,
    event = "BufRead",
    config = function()
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "keyword" })
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
      { "<leader>gg", mode = "n", "<cmd>Gitsigns toggle_current_line_blame<cr>" },
    },
  },
}
