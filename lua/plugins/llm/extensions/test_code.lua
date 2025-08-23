local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")
return {
  handler = tools.side_by_side_handler,
  prompt = prompts.TestCode,
  opts = {
    right = {
      title = " Test Cases ",
    },
  },
}
