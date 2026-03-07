local prompts = require("plugins.llm.prompts")
return {
  handler = "flexi_handler",
  prompt = prompts.CommitMsg,

  opts = {
    fetch_key = vim.env.CHAT_ANYWHERE_KEY,
    url = "https://api.chatanywhere.tech/v1/chat/completions",
    model = "gpt-4o-mini",
    proxy = "noproxy",
    api_type = "openai",
    enter_flexible_window = true,
    apply_visual_selection = false,
    win_opts = {
      relative = "editor",
      position = "50%",
      zindex = 70,
    },
    accept = {
      mapping = {
        mode = "n",
        keys = "<cr>",
      },
      action = function()
        local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

        local tmpname = os.tmpname()
        local f = io.open(tmpname, "w")
        assert(f, "Failed to open tmpfile!")
        for _, line in ipairs(contents) do
          f:write(line, "\n")
        end
        f:close()

        local cmd = "!git commit -F " .. vim.fn.shellescape(tmpname)
        vim.api.nvim_command(cmd)

        os.remove(tmpname)

        -- just for lazygit
        vim.schedule(function()
          vim.api.nvim_command("LazyGit")
        end)
      end,
    },
  },
}
