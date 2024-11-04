return {
  {
    "Kurama622/modeline.nvim",
    event = { "BufReadPost */*" },
    config = function()
      vim.api.nvim_set_hl(0, "Statusline", { fg = "skyblue", bg = "NONE" })
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
        p.progress(),
        p.lsp(),
        p.space(),
        p.space(),
        p.pos(),
      })
    end,
  },
}
