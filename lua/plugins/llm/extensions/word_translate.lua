local prompts = require("plugins.llm.prompts")
return {
  handler = "flexi_handler",
  prompt = prompts.WordTranslate,
  -- prompt = "Translate the following text to English, please only return the translation",
  opts = {
    fetch_key = vim.env.GLM_KEY,
    url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model = "glm-4.5-flash",
    enable_thinking = false,
    api_type = "zhipu",
    proxy = "noproxy",
    win_opts = {
      zindex = 120,
    },
    exit_on_move = true,
    enter_flexible_window = false,
    enable_cword_context = true,
  },
}
