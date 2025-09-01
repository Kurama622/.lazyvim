return {
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        fzf_opts = { ["--cycle"] = true },
        fzf_colors = {
          false, -- inherit fzf colors that aren't specified below from
          -- the auto-generated theme similar to `fzf_colors=true`
          ["fg"] = { "fg", "CursorLine" },
          ["bg"] = { "bg", "Normal" },
          ["hl"] = { "fg", "Comment" },
          ["hl+"] = { "fg", "Statement" },
          ["info"] = { "fg", "PreProc" },
          ["prompt"] = { "fg", "Conditional" },
          ["marker"] = { "bg", "Keyword" },
          ["spinner"] = { "fg", "Label" },
          ["pointer"] = { "fg", "Exception" },
          ["header"] = { "fg", "Comment" },
          ["gutter"] = "-1",
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "Kurama622/llm.nvim" },
    optional = true,
    opts = function(_, opts)
      -- if you wish to use autocomplete
      table.insert(opts.sources, 1, {
        name = "llm",
        group_index = 1,
        priority = 100,
      })

      opts.performance = {
        -- It is recommended to increase the timeout duration due to
        -- the typically slower response speed of LLMs compared to
        -- other completion sources. This is not needed when you only
        -- need manual completion.
        fetching_timeout = 10000,
      }
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = { "Kurama622/llm.nvim" },
    opts = {
      completion = {
        menu = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",

          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  if ctx.item.kind_name == "llm" then
                    return " "
                  else
                    return ctx.kind_icon
                  end
                end,

                highlight = function(ctx)
                  if ctx.item.kind_name == "llm" then
                    return "BlinkCmpKindSnippet"
                  else
                    return ctx.kind_hl
                  end
                end,
              },
            },

            -- columns = {
            --   { "kind_icon", "kind" },
            --   { "label", "label_description", gap = 1 },
            --   { "source_name", "source_id", gap = 1 },
            -- },
          },
        },
        documentation = { window = { border = "rounded" } },
        trigger = {
          prefetch_on_insert = false,
          show_on_blocked_trigger_characters = {},
        },
      },
      signature = { window = { border = "single" } },

      keymap = {
        ["<C-y>"] = {
          function(cmp)
            cmp.show({ providers = { "llm" } })
          end,
        },
      },

      sources = {
        -- if you want to use auto-complete
        default = { "lsp", "path", "snippets", "buffer", "llm" },
        per_filetype = {
          -- optionally inherit from the `default` sources
          llm = { inherit_defaults = false },
        },

        ---@note Windsurf does not require the following configuration
        -- providers = {
        --   llm = {
        --     name = "LLM",
        --     module = "llm.common.completion.frontends.blink",
        --     timeout_ms = 10000,
        --     score_offset = 100,
        --     async = true,
        --   },
        -- },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({ indent = { char = { " " } }, scope = { highlight = highlight, char = { "▎" } } })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      dashboard = { enabled = false },
      indent = { enabled = false },
      -- bigfile = { enabled = true },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
  },
  -- nvim v0.8.0
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.api.nvim_set_hl(0, "LazyGitFloat", { fg = "#c9ece2", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LazyGitBorder", { fg = "#4b5263", bg = "NONE" })
      vim.keymap.set("t", "<C-c>", function()
        vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
        vim.api.nvim_command("LLMAppHandler CommitMsg")
      end, { desc = "AI Commit Msg" })
    end,
  },

  -- run code
  {
    "Kurama622/FloatRun",
    cmd = { "FloatRunToggle", "FloatTermToggle" },
    opts = function()
      return {
        ui = {
          relative = "editor",
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
          -- lua = "lua %s",
          sh = "bash %s",
          Zsh = "bash %s",
          lua = "<builtin>luafile %s",
          rust = "cargo run",
          [""] = "",
        },
      }
    end,
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "FloatTerm",
        callback = function()
          vim.keymap.set("t", "<C-j>", "<cmd>FloatTermNext<CR>", { buffer = true })
          vim.keymap.set("t", "<C-k>", "<cmd>FloatTermPrev<CR>", { buffer = true })
        end,
      })
      return {
        { "<F5>", mode = { "n", "t" }, "<cmd>FloatRunToggle<cr>" },
        { "<F2>", mode = { "n", "t" }, "<cmd>FloatTermToggle<cr>" },
        { "<F14>", mode = { "n", "t" }, "<cmd>FloatTerm<cr>" },
      }
    end,
  },
}
