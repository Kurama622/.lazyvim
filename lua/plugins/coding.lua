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
    "StubbornVegeta/FloatRun",
    cmd = { "FloatRunToggle", "FloatTermToggle" },
    opts = function()
      return {
        ui = {
          border = "single",
          float_hl = "Normal",
          border_hl = "FloatBorder",
          blend = 0,
          height = 0.5,
          width = 0.9,
          x = 0.5,
          y = 0.5,
        },
        run_command = {
          cpp = "g++ -std=c++11 %s -Wall -o {} && {}",
          python = "python %s",
          lua = "lua %s",
          sh = "sh %s",
          [""] = "",
        },
      }
    end,
    keys = {
      { "<F5>", "<cmd>FloatRunToggle<cr>" },
      { "<F2>", mode = { "n", "t" }, "<cmd>FloatTermToggle<cr>" },
    },
  },

  {
    "StubbornVegeta/markdown-org",
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
      { "<leader>mb", "<cmd>call org#main#runCodeBlock()<cr>" },
      { "<leader>ml", "<cmd>call org#main#runLanguage()<cr>" },
    },
  },

  -- ai
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
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
    "StubbornVegeta/style-transfer.nvim",
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
      { "rc", mode = "x", "<cmd>TransferCamelCase<cr>" },
      { "rm", mode = "x", "<cmd>TransferMixedCase<cr>" },
      { "r_", mode = "x", "<cmd>TransferStrCase _<cr>" },
      { "r-", mode = "x", "<cmd>TransferStrCase -<cr>" },
      { "r.", mode = "x", "<cmd>TransferStrCase .<cr>" },
    },
  },
}
