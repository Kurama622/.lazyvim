return {
  {
    "nvimdev/modeline.nvim",
    event = { "BufReadPost */*" },
    config = function()
      require("modeline").setup()
    end,
  },
}
