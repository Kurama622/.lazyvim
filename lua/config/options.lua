local opt, g, env, fn, lsp, diagnostic = vim.opt, vim.g, vim.env, vim.fn, vim.lsp, vim.diagnostic

g.mapleader = " "
g.maplocalleader = "\\"
g.autoformat = true

-- tab -> spaces
-- :retab!
opt.listchars = { tab = "▸~", trail = "▫" }
opt.fillchars:append({ diff = " " })
opt.shiftwidth = 2
opt.tabstop = 2
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.completeopt = "menu,menuone,noselect"
-- opt.fileencodings = { "utf-8", "gbk", "ucs-bom", "cp936" }
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.clipboard = env.SSH_TTY and "" or "unnamedplus"
opt.wrap = true
opt.linebreak = false
opt.spell = false
opt.termguicolors = true
opt.conceallevel = 2
opt.undofile = true
opt.undolevels = 10000
opt.smartindent = true
opt.laststatus = 3
opt.timeoutlen = 1000

local function setup_lsp()
  local config_files = fn.glob(fn.stdpath("config") .. "/lsp/*.lua", false, true)
  local servers = {}

  for _, file in ipairs(config_files) do
    local server_name = fn.fnamemodify(file, ":t:r")
    table.insert(servers, server_name)
  end

  lsp.enable(servers)
end

setup_lsp()
diagnostic.config({ signs = { text = { "", "󰠠", "", "" } } })
