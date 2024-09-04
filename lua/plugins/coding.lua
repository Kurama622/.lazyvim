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
      { "<leader>mb", "<cmd>call org#main#runCodeBlock()<cr>" },
      { "<leader>ml", "<cmd>call org#main#runLanguage()<cr>" },
    },
  },

  -- ai
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSesionToggle", "LLMSelectedTextHandler" },
    config = function()
      require("llm").setup({
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        -- model = "@cf/qwen/qwen1.5-14b-chat-awq",
        -- prompt = "",
        max_tokens = 4095,

        prefix = {
          user = { text = "😃 ", hl = "Title" },
          assistant = { text = "⚡ ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,

        -- popup window options
        popwin_opts = {
          relative = "cursor",
          position = {
            row = -7,
            col = 15,
          },
          size = {
            height = 20,
            width = "60%",
          },
          enter = true,
          focusable = true,
          zindex = 50,
          border = {
            style = "rounded",
            text = {
              top = " Explain ",
              top_align = "center",
            },
          },
          win_options = {
            winblend = 0,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },

        -- stylua: ignore
        keys = {
          -- The keyboard mapping for the input window.
          ["Input:Submit"]      = { mode = "n", key = "<cr>" },
          ["Input:Cancel"]      = { mode = "n", key = "<C-c>" },
          ["Input:Resend"]      = { mode = "n", key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = "n", key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = "n", key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"]        = { mode = "n", key = "i" },
          ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
          ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
          ["Session:Close"]     = { mode = "n", key = "<esc>" },
        },

        streaming_handler = function(chunk, line, output, bufnr, winid, F)
          if not chunk then
            return output
          end
          local tail = chunk:sub(-1, -1)
          if tail:sub(1, 1) ~= "}" then
            line = line .. chunk
          else
            line = line .. chunk

            local start_idx = line:find("data: ", 1, true)
            local end_idx = line:find("}}]}", 1, true)
            local json_str = nil

            while start_idx ~= nil and end_idx ~= nil do
              if start_idx < end_idx then
                json_str = line:sub(7, end_idx + 3)
              end
              local data = vim.fn.json_decode(json_str)
              output = output .. data.choices[1].delta.content
              F.WriteContent(bufnr, winid, data.choices[1].delta.content)

              if end_idx + 4 > #line then
                line = ""
                break
              else
                line = line:sub(end_idx + 4)
              end
              start_idx = line:find("data: ", 1, true)
              end_idx = line:find("}}]}", 1, true)
            end
          end
          return output
        end,
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      { "<leader>t", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
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
      { "rc", mode = "x", "<cmd>TransferCamelCase<cr>" },
      { "rm", mode = "x", "<cmd>TransferMixedCase<cr>" },
      { "r_", mode = "x", "<cmd>TransferStrCase _<cr>" },
      { "r-", mode = "x", "<cmd>TransferStrCase -<cr>" },
      { "r.", mode = "x", "<cmd>TransferStrCase .<cr>" },
    },
  },

  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    on_filetype = "markdown",
    keys = {
      { "<leader>tm", mode = "n", "<cmd>TableModeToggle<cr>" },
    },
  },
}
