-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api, cmd, b, g = vim.api, vim.cmd, vim.b, vim.g
local uv = vim.loop
local fs_stat, fs_open, fs_write, fs_close = uv.fs_stat, uv.fs_open, uv.fs_write, uv.fs_close

g.clangd_version_for_cpp = "c++17"
g.clangd_version_for_c = "c17"

local function file_exists(path)
  local stat = fs_stat(path)
  return stat and stat.type == "file"
end

local function find_project_root(bufnr)
  bufnr = bufnr or 0
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    return nil
  end
  return vim.fs.dirname(
    vim.fs.find({ ".git", "compile_commands.json", "configure.ac" }, { path = fname, upward = true })[1]
  )
end

local function has_any_clang_config(root, clang_files)
  for _, name in ipairs(clang_files) do
    if file_exists(root .. "/" .. name) then
      return true
    end
  end
  return false
end

local function generate_clangd(root)
  local clangd_file = root .. "/.clangd"

  local fd = assert(fs_open(clangd_file, "w", 420)) -- 0644
  fs_write(
    fd,
    string.format(
      [[
CompileFlags:
  Add: []

---
If:
  PathMatch: .*\.c$
CompileFlags:
  Add: [-std=%s]

---
If:
  PathMatch: .*\.(cpp|cc|cxx|hpp|hxx|hh)$
CompileFlags:
  Add: [-std=%s]
]],
      g.clangd_version_for_c,
      g.clangd_version_for_cpp
    )
  )
  fs_close(fd)

  vim.notify(
    "Clangd set " .. vim.bo.ft .. " version: " .. g["clangd_version_for_" .. vim.bo.ft],
    vim.log.levels.INFO,
    { title = "[Set .clangd for C/C++]" }
  )
end

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp" },
  callback = function(args)
    b.autoformat = false
    local clang_files = {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
    }
    local root = find_project_root(args.bufnr)
    if not root then
      return
    end

    if not has_any_clang_config(root, clang_files) then
      generate_clangd(root)
    end
  end,
})

api.nvim_create_user_command("Lg", function(opts)
  cmd("LazyGit" .. table.concat(opts.fargs, " "))
end, {
  nargs = "*",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line([['"]])
    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})
