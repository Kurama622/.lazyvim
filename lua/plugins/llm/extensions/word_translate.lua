local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")
return {
  handler = tools.flexi_handler,
  prompt = prompts.WordTranslate,
  -- prompt = "Translate the following text to English, please only return the translation",
  opts = {
    fetch_key = vim.env.GLM_KEY,
    url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model = "glm-4-flash",
    api_type = "zhipu",
    win_opts = {
      zindex = 120,
    },
    -- args = [=[return string.format([[curl %s -N -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d '%s']], url, LLM_KEY, vim.fn.json_encode(body))]=],
    -- args = [[return {url, "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
    exit_on_move = false,
    enter_flexible_window = true,
  },
}
