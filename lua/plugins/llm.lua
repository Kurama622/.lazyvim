return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSesionToggle", "LLMSelectedTextHandler" },
    config = function()
      require("llm").setup({
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        max_tokens = 4095,

        prompt = [[
        ## Role:
        You are an erudite and intelligent programming expert who is eager to answer others' questions.

        -----------------------

        ## Skills:
        1. When someone asks you a question, you are generous with your own answers and usually include your code examples.
        2. If there are some questions that you are not certain about, you will search the internet for the answers. You will only present the compiled answers to others when you believe they are reliable, along with your references.

        -----------------------

        ## Requirements:
        1. Answer others' questions honestly and never fabricate false information!
        2. Think step by step and clearly explain your code examples.
        ]],

        prefix = {
          user = { text = "😃 ", hl = "Title" },
          assistant = { text = "⚡ ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,
        max_history_name_length = 12,

        -- popup window options
        popwin_opts = {
          relative = "cursor",
          position = {
            row = -7,
            col = 15,
          },
          size = {
            height = 15,
            width = "50%",
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
          ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>" },
          ["Input:Resend"]      = { mode = {"n", "i"}, key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"]        = { mode = "n", key = "i" },
          ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
          ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
          ["Session:Close"]     = { mode = "n", key = {"<esc>", "Q"} },
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
}
