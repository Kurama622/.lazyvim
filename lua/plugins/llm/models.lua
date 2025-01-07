local utils = require("plugins.llm.utils")
return {
  Cloudflare = {
    -- model = "@cf/qwen/qwen1.5-14b-chat-awq",
    model = "@cf/google/gemma-7b-it-lora",
    api_type = "workers-ai",
    max_tokens = 1024,
    fetch_key = function()
      return utils.switch("enable_workers_ai")
    end,
  },
  OpenRouter = {
    url = "https://openrouter.ai/api/v1/chat/completions",
    model = "google/gemini-2.0-flash-exp:free",
    max_tokens = 8000,
    api_type = "openai",
    fetch_key = function()
      return utils.switch("enable_openrouter")
    end,
  },
  GLM = {
    url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model = "glm-4-flash",
    max_tokens = 8000,
    fetch_key = function()
      return utils.switch("enable_glm")
    end,
  },
  Kimi = {
    url = "https://api.moonshot.cn/v1/chat/completions",
    model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
    api_type = "openai",
    max_tokens = 4096,
    fetch_key = function()
      return utils.switch("enable_kimi")
    end,
  },
  Ollama = {
    url = "http://localhost:11434/api/chat",
    model = "llama3.2:1b",
    api_type = "ollama",
    fetch_key = function()
      return utils.switch("enable_local")
    end,
  },
  LocalLLM = {
    url = "http://localhost:11434/api/chat",
    model = "llama3.2:1b",
    api_type = "ollama",
    fetch_key = function()
      return utils.switch("enable_local")
    end,
    streaming_handler = utils.local_llm_streaming_handler,
    parse_handler = utils.local_llm_parse_handler,
  },
  GithubModels = {
    url = "https://models.inference.ai.azure.com/chat/completions",
    model = "gpt-4o",
    api_type = "openai",
    -- max_tokens = 4096,
    max_tokens = 8000,
    -- model = "gpt-4o-mini",
    fetch_key = function()
      return utils.switch("enable_gpt")
    end,
  },
  DeepSeek = {
    url = "https://api.deepseek.com/chat/completions",
    model = "deepseek-chat",
    api_type = "openai",
    max_tokens = 8000,
    fetch_key = function()
      return utils.switch("enable_deepseek")
    end,
  },
  SiliconFlow = {
    url = "https://api.siliconflow.cn/v1/chat/completions",
    -- model = "THUDM/glm-4-9b-chat",
    api_type = "openai",
    max_tokens = 4096,
    -- model = "01-ai/Yi-1.5-9B-Chat-16K",
    -- model = "google/gemma-2-9b-it",
    -- model = "meta-llama/Meta-Llama-3.1-8B-Instruct",
    model = "Qwen/Qwen2.5-7B-Instruct",
    -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
    -- model = "internlm/internlm2_5-7b-chat",
    fetch_key = function()
      return utils.switch("enable_siliconflow")
    end,
  },
}
