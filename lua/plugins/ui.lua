local treesitter = require("nvim-treesitter")
local function treelocation()
  return treesitter.statusline({
    indicator_size = 100,
    -- type_patterns = { "class", "function", "method", "for", "while", "if", "switch", "case" },
    type_patterns = { "class", "function", "method" },
    separator = " ▸ ",
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "jellybeans",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_c = {
            "filename",
            { treelocation, color = LazyVim.ui.fg("Type") },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = LazyVim.ui.fg("Statement"),
            },
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      })
    end,
  },
}
