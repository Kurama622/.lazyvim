local utils = {}
function utils.switch(shell_func)
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

function utils.local_llm_streaming_handler(chunk, line, assistant_output, bufnr, winid, F)
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

function utils.local_llm_parse_handler(chunk)
  local assistant_output = chunk.message.content
  return assistant_output
end
return utils
