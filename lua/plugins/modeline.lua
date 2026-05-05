return {
  {
    "Kurama622/modeline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local p = require("modeline.provider")
      require("modeline").setup({
        p.mode(),
        p.eol(),
        p.filestatus(),
        p.separator(),
        p.fileinfo(),
        p.separator(),
        p.gitinfo(),
        p.space(),
        p.leftpar(),
        p.filetype(),
        p.diagnostic(),
        p.rightpar(),
        p.space(),
        p.progress(),
        p.lsp(),
        p.space(),
        p.visual_selected(),
        p.pos(),
      })
    end,
  },
  {
    "Kurama622/context.lua",
    cmd = "ShowContext",
    keys = {
      { "<C-g>", "<cmd>ShowContext<CR>", desc = "Show Context" },
    },
  },
}
