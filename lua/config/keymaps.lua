-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set("n", "S", "<cmd>w<cr>")
keymap.set("n", "Q", "<cmd>quit<cr>")
keymap.set("n", "<leader>d", "<cmd>Dashboard<cr>")
keymap.set("n", "<leader>rc", "<cmd>e ~/.config/nvim/lua/<cr>")
