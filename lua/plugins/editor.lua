---@diagnostic disable: undefined-global
local api, keymap, diagnostic = vim.api, vim.keymap, vim.diagnostic
local cmd, o, fn = vim.cmd, vim.o, vim.fn
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      lazygit = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
    },

    -- stylua: ignore start
    keys = {
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- git
      { "<leader>fg", function() Snacks.lazygit.open() end, desc = "Open LazyGit" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Rename" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      { "<leader>N", desc = "Neovim News",
        function()
          Snacks.win({
            file = api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    -- stylua: ignore end
    init = function()
      api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if o.filetype == "lazy" then
        cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        custom_filter = function(bufnr, _)
          if vim.bo[bufnr].ft == "qf" then
            return false
          end
          return true
        end,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- dependencies = {
    --   "echasnovski/mini.icons",
    -- },
    config = function()
      require("fzf-lua").setup({
        -- defaults = {
        --   file_icons = true,
        --   git_icons = false, -- show git icons (requires a colorscheme that supports git signs)
        --   color_icons = true, -- colorize file/git icons
        -- },
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
    -- stylua: ignore start
    keys = {
      { "<leader><space>", function() require("fzf-lua").files({ cwd = vim.uv.cwd() }) end, desc = "Find Files" },
      { "<leader>ff", function() require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") }) end,
        desc = "Find Files (current buffer dir)" },
      { "<leader>fc", "<cmd>FzfLua files cwd=$HOME/.config/nvim<CR>", desc = "Open Configs" },
      { "<leader>fl", "<cmd>FzfLua files cwd=~/.config/nvim/lua/plugins/llm<cr>", desc = "Open Configs(llm.nvim)" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Open Recent Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Open Buffers" },
      { "<leader>cs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Open Symbols" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Find Command History" },
    },
    -- stylua: ignore end
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   version = false, -- last release is way too old
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "Kurama622/llm.nvim",
  --   },
  --   -- Not all LSP servers add brackets when completing a function.
  --   -- To better deal with this, LazyVim adds a custom option to cmp,
  --   -- that you can configure. For example:
  --   --
  --   -- ```lua
  --   -- opts = {
  --   --   auto_brackets = { "python" }
  --   -- }
  --   -- ```
  --   opts = function()
  --     -- Register nvim-cmp lsp capabilities
  --     vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
  --
  --     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --     local cmp = require("cmp")
  --     local defaults = require("cmp.config.default")()
  --     local auto_select = true
  --     return {
  --       auto_brackets = {}, -- configure any filetype to auto add brackets
  --       completion = {
  --         completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
  --       },
  --       preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "lazydev" },
  --         { name = "nvim_lsp" },
  --         { name = "path" },
  --       }, {
  --         { name = "buffer" },
  --         {
  --           name = "llm",
  --           group_index = 1,
  --           priority = 100,
  --         },
  --       }),
  --       sorting = defaults.sorting,
  --       performance = {
  --         -- It is recommended to increase the timeout duration due to
  --         -- the typically slower response speed of LLMs compared to
  --         -- other completion sources. This is not needed when you only
  --         -- need manual completion.
  --         fetching_timeout = 10000,
  --       },
  --     }
  --   end,
  -- },

  {
    "saghen/blink.cmp",
    dependencies = { "Kurama622/llm.nvim" },
    version = "1.*",
    opts = {
      fuzzy = {
        implementation = "lua",
      },
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
        preset = "default",
        ["<C-y>"] = {
          function(cmp)
            cmp.show({ providers = { "llm" } })
          end,
        },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-space>"] = { "hide" },
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
    "Kurama622/fsbuffer.nvim",
    cmd = "Fsbuffer",
    opts = { search = { cmd = "fzf-fd" } },
    -- stylua: ignore start
    keys = {
      { "<leader>e", desc = "Fsbuffer (Current Buffer Dir)",
        function() require("fsbuffer"):toggle(vim.fn.expand("%:p:h") .. "/") end
      },
      { "<leader>E", desc = "Fsbuffer (Root Dir)",
        function() require("fsbuffer"):toggle(vim.fs.root(0, ".git") .. "/") end,
      },
    },
    -- stylua: ignore end
  },
  {
    "Kurama622/qfrun.nvim",
    opts = {
      parse_stdout_as_stderr = false,
    },
    keys = {
      { "<F5>", "<cmd>QfCompile<CR>", desc = "compile" },
      { "<F17>", "<cmd>QfRecompile<CR>", desc = "recompile" },
      { "<C-c>", "<cmd>QfClose<CR>", desc = "close" },
    },
  },
  {
    "nvimdev/indentmini.nvim",
    config = function()
      cmd.highlight("IndentLineCurrent guifg=#000000")
      require("indentmini").setup({
        char = "▌",
        only_current = true,
        exclude = { "markdown", "profile" },
      })
    end,
  },

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
      api.nvim_set_hl(0, "LazyGitFloat", { fg = "#c9ece2", bg = "NONE" })
      api.nvim_set_hl(0, "LazyGitBorder", { fg = "#4b5263", bg = "NONE" })
      keymap.set("t", "<C-c>", function()
        api.nvim_win_close(api.nvim_get_current_win(), true)
        api.nvim_command("LLMAppHandler CommitMsg")
      end, { desc = "AI Commit Msg" })
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      diagnostic.config({
        virtual_lines = true,
      })
      require("lsp_lines").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
