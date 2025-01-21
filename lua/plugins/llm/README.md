If you're not bothered by long individual files, or if you only want to copy a part of the configuration from mine, you can refer to the following configuration:

~~~lua
local function switch(shell_func)
  -- [LINK] https://github.com/Kurama622/dotfiles/blob/main/zsh/module/func.zsh
  local p = io.popen(string.format("source ~/.config/zsh/module/func.zsh; %s; echo $LLM_KEY", shell_func))
  if not p then
    vim.notify("failed to get llm key", vim.log.levels.ERROR)
    return " "
  end
  local key = p:read()
  p:close()
  return key
end

local function local_llm_streaming_handler(chunk, line, assistant_output, bufnr, winid, F)
  if not chunk then
    return assistant_output
  end
  local tail = chunk:sub(-1, -1)
  if tail:sub(1, 1) ~= "}" then
    line = line .. chunk
  else
    line = line .. chunk
    local status, data = pcall(vim.fn.json_decode, line)
    if not status or not data.message.content then
      return assistant_output
    end
    assistant_output = assistant_output .. data.message.content
    F.WriteContent(bufnr, winid, data.message.content)
    line = ""
  end
  return assistant_output
end

local function local_llm_parse_handler(chunk)
  local assistant_output = chunk.message.content
  return assistant_output
end

return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      local tools = require("llm.common.tools")
      -- vim.api.nvim_set_hl(0, "Query", { fg = "#6aa84f", bg = "NONE" })
      require("llm").setup({
        -- enable_trace = true,
        -- -- [[ cloudflare ]]     params: api_type =  "workers-ai" | "openai" | "zhipu" | "ollama"
        -- -- model = "@cf/qwen/qwen1.5-14b-chat-awq",
        -- model = "@cf/google/gemma-7b-it-lora",
        -- api_type = "workers-ai",
        -- fetch_key = function()
        --   return switch("enable_workers_ai")
        -- end,

        -- [[ openrouter]]
        -- url = "https://openrouter.ai/api/v1/chat/completions",
        -- model = "google/gemini-2.0-flash-exp:free",
        -- max_tokens = 8000,
        -- api_type = "openai",
        -- fetch_key = function()
        --   return switch("enable_openrouter")
        -- end,

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
        -- api_type = "ollama",
        -- fetch_key = function()
        --   return switch("enable_local")
        -- end,
        -- streaming_handler = local_llm_streaming_handler,
        -- parse_handler = local_llm_parse_handler,

        -- [[ Github Models ]]
        url = "https://models.inference.ai.azure.com/chat/completions",
        model = "gpt-4o",
        api_type = "openai",
        -- max_tokens = 4096,
        max_tokens = 8000,
        -- model = "gpt-4o-mini",
        fetch_key = function()
          return switch("enable_gpt")
        end,

        -- [[deepseek]]
        -- url = "https://api.deepseek.com/chat/completions",
        -- model = "deepseek-chat",
        -- api_type = "openai",
        -- max_tokens = 8000,
        -- fetch_key = function()
        --   return switch("enable_deepseek")
        -- end,

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

        display = {
          diff = {
            layout = "vertical", -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "mini_diff", -- default|mini_diff
          },
        },
        -- style = "right",
        --[[ custom request args ]]
        -- args = [[return {url, "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
        -- history_path = "/tmp/llm-history",
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
            opts = {
              -- streaming_handler = local_llm_streaming_handler,
              left = {
                focusable = false,
              },
            },
          },
          TestCode = {
            handler = tools.side_by_side_handler,
            prompt = [[Write some test cases for the following code, only return the test cases.
            Give the code content directly, do not use code blocks or other tags to wrap it.]],
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
              model = "gpt-4o-mini",
              api_type = "openai",
              language = "Chinese",
            },
          },

          DocString = {
            prompt = [[You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],
            handler = tools.action_handler,
            opts = {
              fetch_key = function()
                return switch("enable_gpt")
              end,
              url = "https://models.inference.ai.azure.com/chat/completions",
              model = "gpt-4o-mini",
              api_type = "openai",
              only_display_diff = true,
              templates = {
                lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".
]],
              },
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

              component_width = "60%",
              component_height = "50%",
              query = {
                title = " 󰊿 Trans ",
                hl = { link = "Define" },
              },
              input_box_opts = {
                size = "15%",
                win_options = {
                  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
              },
              preview_box_opts = {
                size = "85%",
                win_options = {
                  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
              },
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
            -- prompt = "Translate the following text to English, please only return the translation",
            opts = {
              fetch_key = function()
                return switch("enable_glm")
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
              -- args = [=[return string.format([[curl %s -N -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d '%s']], url, LLM_KEY, vim.fn.json_encode(body))]=],
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
          CommitMsg = {
            handler = tools.flexi_handler,
            prompt = function()
              return string.format(
                [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
1. Start with an action verb (e.g., feat, fix, refactor, chore, etc.), followed by a colon.
2. Briefly mention the file or module name that was changed.
3. Describe the specific changes made.

Examples:
- feat: update common/util.py, added test cases for util.py
- fix: resolve bug in user/auth.py related to login validation
- refactor: optimize database queries in models/query.py

Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

```diff
%s
```
]],
                vim.fn.system("git diff --no-ext-diff --staged")
              )
            end,

            opts = {
              fetch_key = function()
                return switch("enable_glm")
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
              enter_flexible_window = true,
              apply_visual_selection = false,
              win_opts = {
                relative = "editor",
                position = "50%",
              },
              accept = {
                mapping = {
                  mode = "n",
                  keys = "<cr>",
                },
                action = function()
                  local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)
                  vim.api.nvim_command(string.format('!git commit -m "%s"', table.concat(contents)))
                  -- just for lazygit
                  vim.schedule(function()
                    vim.api.nvim_command("LazyGit")
                  end)
                end,
              },
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
      { "<leader>ag", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>" },
      { "<leader>ad", mode = "v", "<cmd>LLMAppHandler DocString<cr>" },
      -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
      -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      -- { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
~~~
