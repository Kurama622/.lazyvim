local Popup = require("nui.popup")
local Layout = require("nui.layout")
local NuiText = require("nui.text")

local function CreatePopup(text, focusable, opts)
  local options = {
    focusable = focusable,
    border = { style = "rounded", text = { top = text, top_align = "center" } },
  }
  options = vim.tbl_deep_extend("force", options, opts or {})

  return Popup(options)
end

local function CreateLayout(_width, _height, boxes, opts)
  local options = {
    relative = "editor",
    position = "50%",
    size = {
      width = _width,
      height = _height,
    },
  }
  options = vim.tbl_deep_extend("force", options, opts or {})
  return Layout(options, boxes)
end

local function SetBoxOpts(box_list, opts)
  for i, v in ipairs(box_list) do
    vim.api.nvim_set_option_value("filetype", opts.filetype[i], { buf = v.bufnr })
    vim.api.nvim_set_option_value("buftype", opts.buftype, { buf = v.bufnr })
    vim.api.nvim_set_option_value("spell", opts.spell, { win = v.winid })
    vim.api.nvim_set_option_value("wrap", opts.wrap, { win = v.winid })
    vim.api.nvim_set_option_value("linebreak", opts.linebreak, { win = v.winid })
    vim.api.nvim_set_option_value("number", opts.number, { win = v.winid })
  end
end

local streaming_handler = function(chunk, line, output, bufnr, winid, F)
  if not chunk then
    return output
  end
  local tail = chunk:sub(-1, -1)
  if tail:sub(1, 1) ~= "}" then
    line = line .. chunk
  else
    line = line .. chunk

    local start_idx = line:find("data: ", 1, true)
    local end_idx = line:find("}}]}", 1, true)
    local json_str = nil

    while start_idx ~= nil and end_idx ~= nil do
      if start_idx < end_idx then
        json_str = line:sub(7, end_idx + 3)
      end
      local data = vim.fn.json_decode(json_str)
      output = output .. data.choices[1].delta.content
      F.WriteContent(bufnr, winid, data.choices[1].delta.content)

      if end_idx + 4 > #line then
        line = ""
        break
      else
        line = line:sub(end_idx + 4)
      end
      start_idx = line:find("data: ", 1, true)
      end_idx = line:find("}}]}", 1, true)
    end
  end
  return output
end

local optimize_code_handler = function(name, F, state, streaming)
  local ft = vim.bo.filetype
  local prompt = [[优化代码, 修改语法错误, 让代码更简洁, 增强可复用性，
            你要像copliot那样，直接给出代码内容, 不要使用代码块或其他标签包裹!

            下面是一个例子，假设我们需要优化下面这段代码:
            void test() {
             return 0
            }

            输出结果应该为：
            int test() {
              return 0;
            }

            请按照格式，帮我优化这段代码：
            ]]

  local source_content = F.GetVisualSelection()

  local source_box = CreatePopup(" Source ", false)
  local preview_box = CreatePopup(" Preview ", true, { enter = true })

  local layout = CreateLayout(
    "80%",
    "55%",
    Layout.Box({
      Layout.Box(source_box, { size = "50%" }),
      Layout.Box(preview_box, { size = "50%" }),
    }, { dir = "row" })
  )

  layout:mount()

  SetBoxOpts({ source_box, preview_box }, {
    filetype = { ft, ft },
    buftype = "nofile",
    spell = false,
    number = true,
    wrap = true,
    linebreak = false,
  })

  state.popwin = source_box
  F.WriteContent(source_box.bufnr, source_box.winid, source_content)

  state.app["session"][name] = {}
  table.insert(state.app.session[name], { role = "user", content = prompt .. "\n" .. source_content })

  state.popwin = preview_box
  local worker = streaming(preview_box.bufnr, preview_box.winid, state.app.session[name])

  preview_box:map("n", "<C-c>", function()
    if worker.job then
      worker.job:shutdown()
      worker.job = nil
    end
  end)

  preview_box:map("n", { "<esc>", "N", "n" }, function()
    if worker.job then
      worker.job:shutdown()
      print("Suspend output...")
      vim.wait(1000, function() end)
      worker.job = nil
    end
    layout:unmount()
  end)

  preview_box:map("n", { "Y", "y" }, function()
    vim.api.nvim_command("normal! ggVGky")
    layout:unmount()
  end)
end

local translate_handler = function(name, _, state, streaming)
  local prompt = [[请帮我把这段汉语翻译成英语, 直接给出翻译结果: ]]

  local input_box = Popup({
    enter = true,
    border = {
      style = "solid",
      text = {
        top = NuiText(" 󰊿 Trans ", "CurSearch"),
        top_align = "center",
      },
    },
  })

  local separator = Popup({
    border = { style = "none" },
    enter = false,
    focusable = false,
    win_options = { winblend = 0, winhighlight = "Normal:Normal" },
  })

  local preview_box = Popup({
    focusable = true,
    border = { style = "solid", text = { top = "", top_align = "center" } },
  })

  local layout = CreateLayout(
    "60%",
    "55%",
    Layout.Box({
      Layout.Box(input_box, { size = "15%" }),
      Layout.Box(separator, { size = "5%" }),
      Layout.Box(preview_box, { size = "80%" }),
    }, { dir = "col" })
  )

  layout:mount()

  SetBoxOpts({ preview_box }, {
    filetype = { "markdown", "markdown" },
    buftype = "nofile",
    spell = false,
    number = false,
    wrap = true,
    linebreak = false,
  })

  local worker = { job = nil }

  state.app["session"][name] = {}
  input_box:map("n", "<enter>", function()
    local input_table = vim.api.nvim_buf_get_lines(input_box.bufnr, 0, -1, true)
    local input = table.concat(input_table, "\n")
    vim.api.nvim_buf_set_lines(input_box.bufnr, 0, -1, false, {})
    if input ~= "" then
      table.insert(state.app.session[name], { role = "user", content = prompt .. "\n" .. input })
      state.popwin = preview_box
      worker = streaming(preview_box.bufnr, preview_box.winid, state.app.session[name])
    end
  end)

  input_box:map("n", { "J", "K" }, function()
    vim.api.nvim_set_current_win(preview_box.winid)
  end)
  preview_box:map("n", { "J", "K" }, function()
    vim.api.nvim_set_current_win(input_box.winid)
  end)

  for _, v in ipairs({ input_box, preview_box }) do
    v:map("n", { "<esc>", "N", "n" }, function()
      if worker.job then
        worker.job:shutdown()
        print("Suspend output...")
        vim.wait(1000, function() end)
        worker.job = nil
      end
      layout:unmount()
    end)

    v:map("n", { "Y", "y" }, function()
      vim.api.nvim_set_current_win(preview_box.winid)
      vim.api.nvim_command("normal! ggVGky")
      layout:unmount()
    end)
  end
end

return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSesionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      require("llm").setup({
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        max_tokens = 4095,

        prompt = [[
        ## Role:
        You are an erudite and intelligent programming expert who is eager to answer others' questions.

        -----------------------

        ## Skills:
        1. When someone asks you a question, you are generous with your own answers and usually include your code examples.
        2. If there are some questions that you are not certain about, you will search the internet for the answers. You will only present the compiled answers to others when you believe they are reliable, along with your references.

        -----------------------

        ## Requirements:
        1. Answer others' questions honestly and never fabricate false information!
        2. Think step by step and clearly explain your code examples.
        ]],

        prefix = {
          user = { text = "😃 ", hl = "Title" },
          -- user = { text = "  ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,
        max_history_name_length = 12,

        -- popup window options
        popwin_opts = {
          relative = "cursor",
          position = {
            row = -7,
            col = 15,
          },
          size = {
            height = 15,
            width = "50%",
          },
          enter = true,
          focusable = true,
          zindex = 50,
          border = {
            style = "rounded",
            text = {
              top = " Explain ",
              top_align = "center",
            },
          },
          win_options = {
            winblend = 0,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },

        -- stylua: ignore
        keys = {
          -- The keyboard mapping for the input window.
          ["Input:Submit"]      = { mode = "n", key = "<cr>" },
          ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>" },
          ["Input:Resend"]      = { mode = {"n", "i"}, key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"]        = { mode = "n", key = "i" },
          ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
          ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
          ["Session:Close"]     = { mode = "n", key = {"<esc>", "Q"} },
        },

        streaming_handler = streaming_handler,

        app_handler = {
          OptimizeCode = optimize_code_handler,
          Translate = translate_handler,
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      { "<leader>t", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
      { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>" },
      { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>" },
    },
  },
}
