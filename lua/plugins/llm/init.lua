local models = require("plugins.llm.models")
local ui = require("plugins.llm.ui")
local keymaps = require("plugins.llm.keymaps")

return {
  {
    "Kurama622/llm.nvim",
    -- dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    dependencies = { "nvim-lua/plenary.nvim", "Kurama622/nui.nvim", "Exafunction/windsurf.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      local apps = require("plugins.llm.app")
      local opts = {
        prompt = "You are a helpful Chinese assistant.",
        enable_trace = false,
        -- log_level = 1,

        spinner = {
          text = { "󰧞󰧞", "󰧞󰧞", "󰧞󰧞", "󰧞󰧞" },
          hl = "Title",
        },

        prefix = {
          user = { text = "  ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },

        display = {
          diff = {
            layout = "vertical", -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "mini_diff", -- default|mini_diff
          },
        },
        --[[ custom request args ]]
        -- args = [[return {url, "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
        -- history_path = "/tmp/llm-history",
        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        -- set models list
        models = {
          models.Chatanywhere,
          models.GithubModels,
          models.SiliconFlow,
          models.GLM,
          models.DeepSeek,
          models.Ollama,
          models.Kimi,
          models.Cloudflare,
        },
      }
      for _, conf in pairs({ ui, apps, keymaps }) do
        opts = vim.tbl_deep_extend("force", opts, conf)
      end

      require("llm").setup(opts)
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
      -- { "<leader>cp", mode = { "v", "n" }, "<cmd>LLMAppHandler Completion<cr>", desc = " Code Completion" },
      -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
      -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      -- { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
