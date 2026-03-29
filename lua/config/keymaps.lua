-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

local function set_keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  keymap.set(mode, lhs, rhs, opts)
end

local all_maps = {
  -- Normal mode mappings
  {
    mode = "n",
    lhs = "S",
    rhs = function()
      if vim.fn.expand("%") ~= "" then
        vim.cmd("silent write")
      else
        vim.ui.input({ prompt = "Save As: " }, function(name)
          if name then
            vim.cmd("silent saveas " .. name)
          end
        end)
      end
    end,
    opts = {
      noremap = true,
      silent = true,
    },
  },
  { mode = "n", lhs = "Q", rhs = "<cmd>quit<cr>" },
  { mode = "n", lhs = "<up>", rhs = ":res +5<cr>", opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<down>", rhs = ":res -5<cr>", opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<left>", rhs = ":vertical resize -5<cr>", opts = { noremap = true, silent = true } },
  { mode = "n", lhs = "<right>", rhs = ":vertical resize +5<cr>", opts = { noremap = true, silent = true } },
  {
    mode = "n",
    lhs = "<leader>am",
    rhs = function()
      require("llm.common.api").ModelsPreview()
    end,
    opts = { noremap = true, silent = true, desc = " AI Models List" },
  },
  { mode = "n", lhs = "<leader><tab><tab>", rhs = "<cmd>tabnew<cr>", opts = { desc = "New Tab" } },
  { mode = "n", lhs = "<leader>-", rhs = "<C-W>s", opts = { desc = "Split Window Below", remap = true } },
  { mode = "n", lhs = "<leader>|", rhs = "<C-W>v", opts = { desc = "Split Window Right", remap = true } },
  {
    mode = { "n", "s" },
    lhs = "<esc>",
    rhs = function()
      vim.cmd("noh")
      return "<esc>"
    end,
    opts = { expr = true, desc = "Escape and Clear hlsearch" },
  },
}

for _, mapping in ipairs(all_maps) do
  set_keymap(mapping.mode, mapping.lhs, mapping.rhs, mapping.opts)
end

-- require("lazy.view.config").keys.close = "<Esc>"

-- <leader>fc open nvim config

local function binary_search(tbl, line)
  local left = 1
  local right = #tbl
  local mid = 0

  while true do
    mid = bit.rshift(left + right, 1)
    if not tbl[mid] then
      return
    end

    local range = tbl[mid].range or tbl[mid].location.range
    if not range then
      return
    end

    if line >= range.start.line and line <= range["end"].line then
      return mid
    elseif line < range.start.line then
      right = mid - 1
    else
      left = mid + 1
    end
    if left > right then
      return
    end
  end
end

set_keymap("n", "<C-g>", function()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }

  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, ctx)
    if err or not result or not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
      return
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local mid = binary_search(result, lnum)

    if not mid then
      return
    end

    local function filter(tbl)
      local filtered = {}
      if tbl.children == nil or vim.tbl_isempty(tbl.children) then
        return {}
      end
      for _, s in ipairs(tbl.children) do
        if
          (s.range["start"].line <= lnum and s.range["end"].line >= lnum)
          and (
            s.kind == vim.lsp.protocol.SymbolKind.Function
            or s.kind == vim.lsp.protocol.SymbolKind.Method
            or s.kind == vim.lsp.protocol.SymbolKind.Class
          )
        then
          table.insert(filtered, s)
        end

        if s.children and not vim.tbl_isempty(s.children) then
          s.children = filter(s)
        end
      end
      return filtered
    end

    result[mid].children = filter(result[mid])

    local symbols = vim.tbl_filter(function(t)
      return t.kind == "Function" or t.kind == "Method" or t.kind == "Class"
    end, vim.lsp.util.symbols_to_items({ result[mid] }, 0, vim.lsp.get_clients({ bufnr = 0 })[1].offset_encoding))

    local symbol_name = vim.tbl_map(function(t)
      local kind = t.text:match("%[(%w+)%]%s*")
      return t.text:gsub("%[" .. kind .. "%]%s*", "%%#@" .. kind:lower() .. "#")
    end, symbols)

    local sep_list = {
      cpp = "::",
      c = "::",
    }

    vim.o.statusline = (" %%=(%s%%##)%%= "):format(
      table.concat(symbol_name, "%#Conceal#" .. (sep_list[vim.o.ft] or "->"))
    )
  end)
end, { desc = "Show Treesitter Context" })
