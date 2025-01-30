-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_user_command("Lg", function(opts)
  vim.cmd("LazyGit" .. table.concat(opts.fargs, " "))
end, {
  nargs = "*",
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.api.nvim_command("LLMAppHandler Completion")
  end,
})
