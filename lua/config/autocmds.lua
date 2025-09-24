-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api, cmd, b = vim.api, vim.cmd, vim.b

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp" },
  callback = function()
    b.autoformat = false
  end,
})

api.nvim_create_user_command("Lg", function(opts)
  cmd("LazyGit" .. table.concat(opts.fargs, " "))
end, {
  nargs = "*",
})

-- api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })
