local Text = require("nui.text")
return {
  chat_ui_opts = {
    relative = "editor",
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:String,FloatBorder:Float",
    },
    input = {
      relative = "editor", -- for split style
      position = {
        row = "80%", -- for split style
        col = "50%",
      },
      border = {
        text = {
          top = Text("  Enter Your Question ", "String"),
          top_align = "center",
        },
      },
      win_options = {
        winblend = 0,
        winhighlight = "Normal:String,FloatBorder:Float",
      },
      size = { row = "10%", col = "80%" },
      order = 1,
    },
    output = {
      size = { row = "90%", col = "80%" },
      order = 2,
    },
    history = {
      size = { row = "100%", col = "20%" },
      order = 3,
    },
  },

  -- popup window options
  popwin_opts = {
    relative = "cursor",
    enter = true,
    focusable = true,
    zindex = 50,
    position = { row = -7, col = 15 },
    size = { height = 15, width = "50%" },
    border = { style = "single", text = { top = " Explain ", top_align = "center" } },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  },
}
