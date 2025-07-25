If you're not bothered by long individual files, or if you only want to copy a part of the configuration from mine, you can refer to the following configuration:

~~~lua
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
    -- If code completion uses Codeium, it requires `Exafunction/codeium.nvim`; otherwise, it does not.
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "Exafunction/codeium.nvim" },
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
        --   return vim.env.WORKERS_AI_KEY
        -- end,

        -- [[ openrouter]]
        -- url = "https://openrouter.ai/api/v1/chat/completions",
        -- model = "google/gemini-2.0-flash-exp:free",
        -- max_tokens = 8000,
        -- api_type = "openai",
        -- fetch_key = function()
        --   return vim.env.OPENROUTER_KEY
        -- end,

        -- [[ GLM ]]
        -- url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        -- model = "glm-4-flash",
        -- max_tokens = 8000,
        -- fetch_key = function()
        --   return vim.env.GLM_KEY
        -- end,

        -- [[ kimi ]]
        -- url = "https://api.moonshot.cn/v1/chat/completions",
        -- model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
        -- api_type = "openai",
        -- max_tokens = 4096,
        -- fetch_key = function()
        --   return vim.env.KIMI_KEY
        -- end,
        -- -- streaming_handler = kimi_handler,

        -- [[ ollama ]]
        -- url = "http://localhost:11434/api/chat",
        -- model = "llama3.2:1b",
        -- api_type = "ollama",
        -- fetch_key = function()
        --   return vim.env.LOCAL_LLM_KEY
        -- end,

        -- [[ local llm ]]
        -- url = "your url",
        -- model = "your model name",
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
          return vim.env.GITHUB_TOKEN
        end,

        -- [[deepseek]]
        -- url = "https://api.deepseek.com/chat/completions",
        -- model = "deepseek-chat",
        -- api_type = "openai",
        -- max_tokens = 8000,
        -- fetch_key = function()
        --   return vim.env.DEEPSEEK_TOKEN
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
        --   return vim.env.SILICONFLOW_TOKEN
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

          -- Scroll [default]
          ["PageUp"]            = { mode = {"i","n"}, key = "<C-b>" },
          ["PageDown"]          = { mode = {"i","n"}, key = "<C-f>" },
          ["HalfPageUp"]        = { mode = {"i","n"}, key = "<C-u>" },
          ["HalfPageDown"]      = { mode = {"i","n"}, key = "<C-d>" },
          ["JumpToTop"]         = { mode = "n", key = "gg" },
          ["JumpToBottom"]      = { mode = "n", key = "G" }
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
                return vim.env.GITHUB_TOKEN
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
                return vim.env.GITHUB_TOKEN
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
                return vim.env.GLM_KEY
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
            prompt = [[You are a translation expert. Your task is to translate all the text provided by the user into Chinese.

          NOTE:
          - All the text input by the user is part of the content to be translated, and you should ONLY FOCUS ON TRANSLATING THE TEXT without performing any other tasks.
          - RETURN ONLY THE TRANSLATED RESULT.]],
            -- prompt = "Translate the following text to English, please only return the translation",
            opts = {
              fetch_key = function()
                return vim.env.GLM_KEY
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
                return vim.env.GLM_KEY
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
          -- Source: https://andrewian.dev/blog/ai-git-commits
          return string.format(
            [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
      1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)
      2. Optional bullet points if more context helps:
        - Keep the second line blank
        - Keep them short and direct
        - Focus on what changed
        - Always be terse
        - Don't overly explain
        - Drop any fluffy or formal language

      Return ONLY the commit message - no introduction, no explanation, no quotes around it.

      Examples:
      feat: add user auth system

      - Add JWT tokens for API auth
      - Handle token refresh for long sessions

      fix: resolve memory leak in worker pool

      - Clean up idle connections
      - Add timeout for stale workers

      Simple change example:
      fix: typo in README.md

      Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided, with a little bit of styling informed by the recent commits you're about to see.

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
                return vim.env.CHAT_ANYWHERE_KEY
              end,
              url = "https://api.chatanywhere.tech/v1/chat/completions",
              model = "gpt-4o-mini",
              api_type = "openai",
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
                  vim.api.nvim_command(string.format('!git commit -m "%s"', table.concat(contents, '" -m "')))

                  -- just for lazygit
                  vim.schedule(function()
                    vim.api.nvim_command("LazyGit")
                  end)
                end,
              },
            },
          },
          Ask = {
            handler = tools.disposable_ask_handler,
            opts = {
              position = {
                row = 2,
                col = 0,
              },
              title = " Ask ",
              inline_assistant = true,
              language = "Chinese",
              url = "https://api.chatanywhere.tech/v1/chat/completions",
              model = "gpt-4o-mini",
              api_type = "openai",
              fetch_key = function()
                return vim.env.CHAT_ANYWHERE_KEY
              end,
              display = {
                mapping = {
                  mode = "n",
                  keys = { "d" },
                },
                action = nil,
              },
              accept = {
                mapping = {
                  mode = "n",
                  keys = { "Y", "y" },
                },
                action = nil,
              },
              reject = {
                mapping = {
                  mode = "n",
                  keys = { "N", "n" },
                },
                action = nil,
              },
              close = {
                mapping = {
                  mode = "n",
                  keys = { "<esc>" },
                },
                action = nil,
              },
            },
          },
          AttachToChat = {
            handler = tools.attach_to_chat_handler,
            opts = {
              is_codeblock = true,
              inline_assistant = true,
              language = "Chinese",
            },
          },
          Completion = {
            handler = tools.completion_handler,
            opts = {
              -------------------------------------------------
              ---                  ollama
              -------------------------------------------------
              -- -- url = "http://localhost:11434/api/generate",
              -- url = "http://localhost:11434/v1/completions",
              -- model = "qwen2.5-coder:1.5b",
              -- api_type = "ollama",

              -------------------------------------------------
              ---                 deepseek
              -------------------------------------------------
              -- url = "https://api.deepseek.com/beta/completions",
              -- model = "deepseek-chat",
              -- api_type = "deepseek",
              -- fetch_key = function()
              --   return vim.env.DEEPSEEK_TOKEN
              -- end,

              -------------------------------------------------
              ---                 codeium
              -------------------------------------------------
              api_type = "codeium",
              style = "virtual_text",

              n_completions = 1,
              context_window = 512,
              max_tokens = 256,
              filetypes = { sh = false },
              default_filetype_enabled = true,
              auto_trigger = true,
              -- style = "blink.cmp",
              -- style = "nvim-cmp",
              -- style = "virtual_text",
              keymap = {
                toggle = {
                  mode = "n",
                  keys = "<leader>cp",
                },
                virtual_text = {
                  accept = {
                    mode = "i",
                    keys = "<A-a>",
                  },
                  next = {
                    mode = "i",
                    keys = "<A-n>",
                  },
                  prev = {
                    mode = "i",
                    keys = "<A-p>",
                  },
                },
              },
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = " Toggle LLM Chat" },
      { "<leader>ts", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>", desc = " Word Translate" },
      { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>", desc = " Explain the Code" },
      { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>", desc = " AI Translator" },
      { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>", desc = " Generate Test Cases" },
      { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>", desc = " Optimize the Code" },
      { "<leader>au", mode = "n", "<cmd>LLMAppHandler UserInfo<cr>", desc = " Check Account Information" },
      { "<leader>ag", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>", desc = " Generate AI Commit Message" },
      { "<leader>ad", mode = "v", "<cmd>LLMAppHandler DocString<cr>", desc = " Generate a Docstring" },
      { "<leader>ak", mode = { "v", "n" }, "<cmd>LLMAppHandler Ask<cr>", desc = " Ask LLM" },
      { "<leader>aa", mode = { "v", "n" }, "<cmd>LLMAppHandler AttachToChat<cr>", desc = " Ask LLM (multi-turn)" },
      -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
      -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      -- { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
~~~
