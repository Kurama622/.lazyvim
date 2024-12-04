local function switch(shell_func)
  -- [LINK] https://github.com/Kurama622/dotfiles/blob/main/zsh/module/func.zsh
  local p = io.popen(string.format("source ~/.config/zsh/module/func.zsh; %s; echo $LLM_KEY", shell_func))
  local key = p:read()
  p:close()
  return key
end

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
        -- url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        -- model = "glm-4-flash",
        -- max_tokens = 8000,
        -- fetch_key = function()
        --   return switch("enable_glm")
        -- end,

        -- [[ kimi ]]
        -- url = "https://api.moonshot.cn/v1/chat/completions",
        -- model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
        -- api_type = "openai",
        -- max_tokens = 4096,
        -- fetch_key = function()
        --   return switch("enable_kimi")
        -- end,
        -- -- streaming_handler = kimi_handler,

        -- [[ local llm ]]
        -- url = "http://localhost:11434/api/chat",
        -- model = "llama3.2:1b",
        -- api_type = "local",
        -- fetch_key = function()
        --   return switch("enable_local")
        -- end,
        -- streaming_handler = function(chunk, line, assistant_output, bufnr, winid, F)
        --   if not chunk then
        --     return assistant_output
        --   end
        --   local tail = chunk:sub(-1, -1)
        --   if tail:sub(1, 1) ~= "}" then
        --     line = line .. chunk
        --   else
        --     line = line .. chunk
        --     local status, data = pcall(vim.fn.json_decode, line)
        --     if not status or not data.message.content then
        --       return assistant_output
        --     end
        --     assistant_output = assistant_output .. data.message.content
        --     F.WriteContent(bufnr, winid, data.message.content)
        --     line = ""
        --   end
        --   return assistant_output
        -- end,

        -- [[ Github Models ]]
        url = "https://models.inference.ai.azure.com/chat/completions",
        model = "gpt-4o",
        api_type = "openai",
        max_tokens = 4096,
        -- model = "gpt-4o-mini",
        fetch_key = function()
          return switch("enable_gpt")
        end,

        -- [[ siliconflow ]]
        -- url = "https://api.siliconflow.cn/v1/chat/completions",
        -- -- model = "THUDM/glm-4-9b-chat",
        -- api_type = "openai",
        -- max_tokens = 4096,
        -- -- model = "01-ai/Yi-1.5-9B-Chat-16K",
        -- -- model = "google/gemma-2-9b-it",
        -- -- model = "meta-llama/Meta-Llama-3.1-8B-Instruct",
        -- model = "Qwen/Qwen2.5-7B-Instruct",
        -- -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
        -- -- model = "internlm/internlm2_5-7b-chat",
        -- -- [optional: fetch_key]
        -- fetch_key = function()
        --   return switch("enable_siliconflow")
        -- end,

        temperature = 0.3,
        top_p = 0.7,

        prompt = "You are a helpful chinese assistant.",

        spinner = {
          text = {
            "󰧞󰧞",
            "󰧞󰧞",
            "󰧞󰧞",
            "󰧞󰧞",
          },
          hl = "Title",
        },

        prefix = {
          -- 
          user = { text = "😃 ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        -- stylua: ignore
        -- popup window options
        popwin_opts = {
          relative = "cursor", enter = true,
          focusable = true, zindex = 50,
          position = { row = -7, col = 15, },
          size = { height = 15, width = "50%", },
          border = { style = "single",
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
            prompt = [[ Write some test cases for the following code, only return the test cases.
            Give the code content directly, do not use code blocks or other tags to wrap it. ]],
            opts = {
              right = {
                title = " Test Cases ",
              },
            },
          },
          OptimCompare = {
            handler = tools.action_handler,
            opts = {
              fetch_key = function()
                return switch("enable_gpt")
              end,
              url = "https://models.inference.ai.azure.com/chat/completions",
              model = "gpt-4o",
              api_type = "openai",
            },
          },

          Translate = {
            handler = tools.qa_handler,
            opts = {
              fetch_key = function()
                return switch("enable_glm")
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
            },
          },

          -- check siliconflow's balance
          UserInfo = {
            handler = function()
              local key = os.getenv("LLM_KEY")
              local res = tools.curl_request_handler(
                "https://api.siliconflow.cn/v1/user/info",
                { "GET", "-H", string.format("'Authorization: Bearer %s'", key) }
              )
              if res ~= nil then
                print("balance: " .. res.data.balance)
              end
            end,
          },
          WordTranslate = {
            handler = tools.flexi_handler,
            prompt = "Translate the following text to Chinese, please only return the translation",
            opts = {
              fetch_key = function()
                return switch("enable_glm")
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
              exit_on_move = true,
              enter_flexible_window = false,
            },
          },
          CodeExplain = {
            handler = tools.flexi_handler,
            prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
            opts = {
              fetch_key = function()
                return switch("enable_glm")
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
              enter_flexible_window = true,
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ts", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>" },
      { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>" },
      { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>" },
      { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>" },
      { "<leader>au", mode = "n", "<cmd>LLMAppHandler UserInfo<cr>" },
      -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
      -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      -- { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
