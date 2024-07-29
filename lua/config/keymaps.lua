-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

local function set_keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  keymap.set(mode, lhs, rhs, opts)
end

-- stylua: ignore
local all_maps = {
  -- Normal mode mappings
  { mode = "n", lhs = "S",   rhs = "<cmd>w<cr>" },
  { mode = "n", lhs = "Q",   rhs = "<cmd>quit<cr>" },
  { mode = "n", lhs = "<leader>d", rhs = "<cmd>Dashboard<cr>" },
  { mode = "n", lhs = "<leader>ai", rhs = "<cmd>CodeiumToggle<cr>" },
  { mode = "n", lhs = "<leader>ac", rhs = "<cmd>call codeium#Chat()<cr>" },

  -- Insert mode mappings
  { mode = "i", lhs = "<C-e>", rhs = function() return vim.fn["codeium#Accept"]() end, opts = { expr = true, silent = true } },
  { mode = "i", lhs = "<c-\\>", rhs = function() return vim.fn["codeium#CycleCompletions"](1) end, opts = { expr = true, silent = true } },
  { mode = "i", lhs = "<c-|>", rhs = function() return vim.fn["codeium#CycleCompletions"](-1) end, opts = { expr = true, silent = true } },
  { mode = "i", lhs = "<c-x>", rhs = function() return vim.fn["codeium#Clear"]() end, opts = { expr = true, silent = true } },
}

for _, mapping in ipairs(all_maps) do
  set_keymap(mapping.mode, mapping.lhs, mapping.rhs, mapping.opts)
end

-- <leader>fc open nvim config
