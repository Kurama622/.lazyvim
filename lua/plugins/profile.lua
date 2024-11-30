return {
  {
    "3rd/image.nvim",
    dependencies = {
      "leafo/magick",
    },
    config = function()
      require("image").setup({
        backend = "ueberzug",
        -- backend = "kitty",
        kitty_method = "normal",
        integrations = {
          markdown = {
            enabled = false,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end,
  },

  {
    "Kurama622/profile.nvim",
    dependencies = { "3rd/image.nvim" },
    config = function()
      local comp = require("profile.components")
      require("profile").setup({
        -- avatar_path = "/home/arch/Github/profile.nvim/resources/profile.png",
        avatar_opts = {
          avatar_width = 20,
          avatar_height = 20,
          avatar_x = function()
            return math.floor((vim.o.columns - 20) / 2) + 39
          end,
          avatar_y = 9,
          force_blank = false,
        },
        user = "Kurama622",
        git_contributions = {
          start_week = 1,
          end_week = 53,
          empty_char = " ",
          full_char = { "", "󰧞", "", "", "" },
          fake_contributions = nil,
          non_official_api_cmd = [[ curl -s "https://github-contributions-api.jogruber.de/v4/%s?y=$(date -d "1 year ago" +%%Y)&y=$(date +%%Y)" \
             | jq --arg start $(date -d "1 year ago" +%%Y-%%m-%%d) --arg end $(date +%%Y-%%m-%%d) \
             '.contributions | [ .[] | select((.date >= $start) and (.date <= $end)) ] | sort_by(.date) | (.[0].date | strptime("%%Y-%%m-%%d") | strftime("%%w") | tonumber) as $wd | map(.count) | ([range(0, $wd) ] | map(0)) + . | . as $array | reduce range(0; length; 7) as $i ({}; . + {($i/7+1 | tostring): $array[$i:$i+7] })' ]],
        },
        hide = {
          statusline = true,
          tabline = true,
        },
        disable_keys = { "h", "j", "k", "<Left>", "<Right>", "<Up>", "<Down>", "<C-f>" },
        cursor_pos = { 9, 26 },
        format = function()
          comp:avatar()
          -- stylua: ignore
          local content = {
            {[[                                                                                      ]], "center", "ProfileRed"},
            {[[                                                                                      ]], "center", "ProfileRed"},
            {[[                                                                                      ]], "center", "ProfileRed"},
            {[[                                                                                      ]], "center", "ProfileRed"},
            {[[ Hi, I'm Kurama! ]], "center", "Title"},
            {[[ Linux  Neovim  Cpp ]], "center", "ProfileGreen"},
            {[[                                                                                                     ]], "center", "ProfileRed"},
            {[[ ⭐️ Neovim Plugins                                                                                   ]], "center", "Title"},
            {[[                                                                                                     ]], "center", "ProfileRed"},
            {[[ [llm.nvim]            Free large language model (LLM) support for Neovim.                           ]], "center", "ProfileRed"},
            {[[ [markdown-org]        Run code in markdown.                                                         ]], "center", "ProfileRed"},
            {[[ [profile.nvim]        Your Personal Homepage.                                                       ]], "center", "ProfileRed"},
            {[[ [FloatRun]            A minimize plugin running code in floating window.                            ]], "center", "ProfileRed"},
            {[[ [style-transfer.nvim] Variable naming style transfer, like vim-abolish.                             ]], "center", "ProfileRed"},
            {[[                                                                                                     ]], "center", "ProfileRed"},
            {[[ 😃 Other Projects                                                                                   ]], "center", "Title"},
            {[[                                                                                                     ]], "center", "ProfileRed"},
            {[[ [StartUp]    Terminal Dashboard.                                                                    ]], "center", "ProfileRed"},
            {[[ [neurovirus] Illustrate Neural Network (python+LaTeX).                                              ]], "center", "ProfileRed"},
            {[[                                                                                                     ]], "center", "ProfileRed"},
            {[[ ─────────────────────────────────────────────────────────────────────────────────────────── ]], "center", "Comment"},
            }
          for _, c in ipairs(content) do
            comp:text_component_render({ comp:text_component(c[1], c[2], c[3]) })
          end
          -- comp:text_component_render({
          --   comp:text_component("git@github.com:Kurama622/profile.nvim", "center", "ProfileRed"),
          --   comp:text_component("──── By Kurama622", "right", "ProfileBlue"),
          -- })
          comp:separator_render()
          comp:card_component_render({
            type = "table",
            content = function()
              return {
                {
                  title = "kurama622/llm.nvim",
                  description = [[LLM Neovim Plugin: Effortless Natural
Language Generation with LLM's API]],
                },
                {
                  title = "kurama622/profile.nvim",
                  description = [[A Neovim plugin: Your Personal Homepage]],
                },
              }
            end,
            hl = {
              border = "ProfileYellow",
              text = "ProfileYellow",
            },
          })
          comp:separator_render()
          comp:git_contributions_render("ProfileGreen")
        end,
      })
      vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>Profile<cr>", { silent = true })

      local user_mappings = {
        n = {
          ["r"] = "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
          ["f"] = "<cmd>lua require('telescope.builtin').find_files()<cr>",
          ["c"] = "<cmd>lua require('telescope.builtin').find_files({ cwd = '$HOME/.config/nvim' })<cr>",
          ["/"] = "<cmd>lua require('telescope.builtin').live_grep()<cr>",
          ["n"] = "<cmd>enew<cr>",
          ["l"] = "<cmd>Lazy<cr>",
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "profile",
        callback = function()
          for mode, mapping in pairs(user_mappings) do
            for key, cmd in pairs(mapping) do
              vim.api.nvim_buf_set_keymap(0, mode, key, cmd, { noremap = true, silent = true })
            end
          end
        end,
      })
    end,
  },
}
