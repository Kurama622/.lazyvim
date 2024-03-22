-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set("n", "S", "<cmd>w<cr>")
keymap.set("n", "Q", "<cmd>quit<cr>")
keymap.set("n", "<leader>d", "<cmd>Dashboard<cr>")

keymap.set("i", "<C-e>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
keymap.set("i", "<c-\\>", function()
  return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true })
keymap.set("i", "<c-|>", function()
  return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true })
keymap.set("i", "<c-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })
keymap.set("n", "<leader>ai", "<cmd>CodeiumToggle<cr>")
keymap.set("n", "<leader>ac", "<cmd>call codeium#Chat()<cr>")

-- <leader>fc open nvim config
