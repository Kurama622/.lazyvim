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
diagnostic.config({ signs = { text = { "", "", "", "" } } })

-- for _, file in ipairs(vim.fn.argv()) do
--   print(file)
-- end

-- local obj = nil
-- vim.keymap.set("n", "<leader>rc", function()
--   local M = {}
--
--   M.windows = {}
--   M.buffers = {}
--
--   function M.open_layout()
--     -- 保存当前 window
--     M.windows.main = vim.api.nvim_get_current_win()
--
--     -- 左侧窗口
--     vim.cmd("vsplit")
--     M.windows.left = vim.api.nvim_get_current_win()
--
--     -- 右侧窗口
--     vim.cmd("vsplit")
--     M.windows.right = vim.api.nvim_get_current_win()
--
--     -- 创建 buffers
--     M.buffers.scopes = vim.api.nvim_create_buf(false, true)
--     M.buffers.repl = vim.api.nvim_create_buf(false, true)
--
--     -- 绑定 buffer
--     vim.api.nvim_win_set_buf(M.windows.left, M.buffers.scopes)
--     vim.api.nvim_win_set_buf(M.windows.right, M.buffers.repl)
--
--     -- 设置 buffer 类型
--     vim.bo[M.buffers.scopes].buftype = "nofile"
--     vim.bo[M.buffers.repl].buftype = "nofile"
--   end
--
--   function M.close_layout()
--     for _, win in pairs(M.windows) do
--       if vim.api.nvim_win_is_valid(win) then
--         vim.api.nvim_win_close(win, true)
--       end
--     end
--   end
--   M.open_layout()
--
--   -- obj = vim.system(
--   --   { "gdb", "test", "/tmp/core.test.1670006.vegeta.1775651993" }, -- 需要交互模式
--   --   {
--   --     stdin = true,
--   --     stdout = function(_, data)
--   --       if data then
--   --         print(data)
--   --       end
--   --     end,
--   --     stderr = function(_, data)
--   --       if data then
--   --         print("ERR:", data)
--   --       end
--   --     end,
--   --   }
--   -- )
-- end)
-- vim.keymap.set("n", "<leader>rr", function()
--   obj:write("bt\n")
-- end)

