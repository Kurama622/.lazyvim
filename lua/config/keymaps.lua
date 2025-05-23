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
  { mode = "n", lhs = "S",          rhs = "<cmd>w<cr>" },
  { mode = "n", lhs = "Q",          rhs = "<cmd>quit<cr>" },
  { mode = "n", lhs = "<leader>d",  rhs = "<cmd>Dashboard<cr>" },
  { mode = "n", lhs = "<up>",       rhs = ":res +5<cr>",             opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<down>",     rhs = ":res -5<cr>",             opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<left>",     rhs = ":vertical resize -5<cr>", opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<right>",    rhs = ":vertical resize +5<cr>", opts = { noremap = true, silent = true } },
  {
    mode = "n", lhs = "<leader>am",
    rhs = function()
      require("llm.common.api").ModelsPreview()
    end,
    opts = { noremap = true, silent = true, desc = " AI Models List" },
  }
}

for _, mapping in ipairs(all_maps) do
  set_keymap(mapping.mode, mapping.lhs, mapping.rhs, mapping.opts)
end

require("lazy.view.config").keys.close = "<Esc>"

-- <leader>fc open nvim config
