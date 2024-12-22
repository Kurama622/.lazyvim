return {
  -- catppuccin
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha", -- latte, frappe, macchiato, mocha
  --       custom_highlights = function()
  --         return {
  --           DiffAdd = { fg = "NONE", bg = "#44cdab" }, -- 添加的部分
  --           DiffChange = { fg = "NONE", bg = "#6183cb" }, -- 修改的部分
  --           DiffDelete = { fg = "NONE", bg = "#914c54" }, -- 删除的部分
  --           DiffText = { fg = "NONE", bg = "#a1c3b2" }, -- 修改的具体文本
  --         }
  --       end,
  --     })
  --   end,
  -- },
  {
    -- tokyonight
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- nvim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "tokyonight-night",
      colorscheme = "tokyonight-moon",
    },
  },
}
