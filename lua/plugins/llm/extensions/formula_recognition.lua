local tools = require("llm.tools")
return {
  handler = tools.images_handler,
  prompt = "Please convert the formula in the image to LaTeX syntax, and only return the syntax of the formula.",
  opts = {
    url = "http://localhost:11434/api/chat",
    model = "qwen2.5vl:3b",
    fetch_key = vim.env.LOCAL_LLM_KEY,
    api_type = "ollama",
    picker = {
      cmd = "fd . ~/Pictures/ | xargs -d '\n' ls -t | fzf --no-preview",
      -- keymap
      mapping = {
        mode = "i",
        keys = "<C-f>",
      },
    },
  },
}
