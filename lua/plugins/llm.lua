return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSesionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      local tools = require("llm.common.tools")
      -- vim.api.nvim_set_hl(0, "Query", { fg = "#6aa84f", bg = "NONE" })
      require("llm").setup({

        -- [[ cloudflared ]]     params: api_type =  "workers.ai" | "openai" | "zhipu"
        -- model = "@cf/qwen/qwen1.5-14b-chat-awq",

        -- [[ GLM ]]
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        max_tokens = 8000,

        -- [[ kimi ]]
        -- url = "https://api.moonshot.cn/v1/chat/completions",
        -- model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
        -- api_type = "openai",
        -- streaming_handler = kimi_handler,
        -- max_tokens = 4096,

        -- [[ Github Models ]]
        -- url = "https://models.inference.ai.azure.com/chat/completions",
        -- model = "gpt-4o-mini",
        -- api_type = "openai",
        -- max_tokens = 4096,

        temperature = 0.3,
        top_p = 0.7,

        prompt = "You are a helpful assistant.",

        -- prompt = [[
        -- ## Role:
        -- You are an erudite and intelligent programming expert who is eager to answer others' questions.
        --
        -- -----------------------
        --
        -- ## Skills:
        -- 1. When someone asks you a question, you are generous with your own answers and usually include your code examples.
        -- 2. If there are some questions that you are not certain about, you will search the internet for the answers. You will only present the compiled answers to others when you believe they are reliable, along with your references.
        --
        -- -----------------------
        --
        -- ## Requirements:
        -- 1. Answer others' questions honestly and never fabricate false information!
        -- 2. Think step by step and clearly explain your code examples.
        -- ]],

        prefix = {
          user = { text = "😃 ", hl = "Title" }, ------------ 
          assistant = { text = "  ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        -- stylua: ignore
        -- popup window options
        popwin_opts = {
          relative = "cursor",
          position = { row = -7, col = 15, },
          size = { height = 15, width = "50%", },
          enter = true,
          focusable = true,
          zindex = 50,
          border = { style = "rounded",
            text = { top = " Explain ", top_align = "center" },
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

        app_handler = {
          OptimizeCode = {
            handler = tools.side_by_side_handler,
          },
          TestCode = {
            handler = tools.side_by_side_handler,
            prompt = "Write a test for the following code, only return the test code:",
            opts = {
              right = {
                title = " Result ",
              },
            },
          },
          OptimCompare = {
            handler = tools.action_handler,
          },
          Translate = {
            handler = tools.qa_handler,
          },
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      { "<leader>t", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
      { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>" },
      { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>" },
      { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>" },
      -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
    },
  },
}
