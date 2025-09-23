vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- tab -> spaces
-- :retab!
vim.opt.listchars = { tab = "▸~", trail = "▫" }
vim.opt.fillchars:append({ diff = " " })
-- vim.opt.fileencodings = { "utf-8", "gbk", "ucs-bom", "cp936" }
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
-- wrap
vim.opt.wrap = true
vim.opt.linebreak = false
-- spell
vim.opt.spell = false

vim.g.autoformat = true

vim.opt.termguicolors = true
