-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- tab -> spaces
-- :retab!
vim.opt.listchars = { tab = "▸~", trail = "▫" }
-- vim.opt.fileencodings = { "utf-8", "gbk", "ucs-bom", "cp936" }
vim.o.expandtab = true
-- wrap
vim.opt.wrap = true
vim.opt.linebreak = false
-- spell
vim.opt.spell = false

vim.g.autoformat = true

vim.opt.termguicolors = true
