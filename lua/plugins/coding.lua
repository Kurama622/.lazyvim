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
    cmd = "FloatRunToggle",
    opts = function()
      local file = vim.api.nvim_buf_get_name(0)
      return {
        ui = {
          border = "single",
          float_hl = "Normal",
          border_hl = "FloatBorder",
          blend = 0,
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,
        },
        run_command = {
          cpp = "g++ -std=c++11 " .. file .. " -Wall -o " .. vim.fn.expand("%<") .. " && ./" .. vim.fn.expand("%<"),
          python = "python " .. file,
          lua = "luafile " .. file,
          sh = "sh " .. file,
          [""] = "",
        },
      }
    end,
    keys = { { "<F5>", "<cmd>FloatRunToggle<cr>" } },
  },
}
