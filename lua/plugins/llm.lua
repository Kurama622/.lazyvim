local Popup = require("nui.popup")
local Layout = require("nui.layout")
local NuiText = require("nui.text")

local function InsertTextLine(bufnr, linenr, text)
  vim.api.nvim_buf_set_lines(bufnr, linenr, linenr, false, { text })
end

local function ReplaceTextLine(bufnr, linenr, text)
  vim.api.nvim_buf_set_lines(bufnr, linenr, linenr + 1, false, { text })
end

local function RemoveTextLines(bufnr, start_linenr, end_linenr)
  vim.api.nvim_buf_set_lines(bufnr, start_linenr, end_linenr, false, {})
end

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

local kimi_handler = function(chunk, line, output, bufnr, winid, F)
  if not chunk then
    return output
  end
  local tail = chunk:sub(-1, -1)
  if tail:sub(1, 1) ~= "}" then
    line = line .. chunk
  else
    line = line .. chunk

    local start_idx = line:find("data: ", 1, true)
    local end_idx = line:find("}]", 1, true)
    local json_str = nil

    while start_idx ~= nil and end_idx ~= nil do
      if start_idx < end_idx then
        json_str = line:sub(7, end_idx + 1) .. "}"
      end
      local data = vim.fn.json_decode(json_str)
      if not data.choices[1].delta.content then
        break
      end

      output = output .. data.choices[1].delta.content
      F.WriteContent(bufnr, winid, data.choices[1].delta.content)

      if end_idx + 2 > #line then
        line = ""
        break
      else
        line = line:sub(end_idx + 2)
      end
      start_idx = line:find("data: ", 1, true)
      end_idx = line:find("}]", 1, true)
    end
  end
  return output
end

local ShowDiff = function(
  bufnr,
  start_str,
  end_str,
  mark_id,
  extmark,
  extmark_opts,
  space_text,
  start_line,
  end_line,
  codeln,
  offset,
  ostr
)
  local pattern = string.format("%s(.-)%s", start_str, end_str)
  local res = ostr:match(pattern)
  if res == nil then
    print("The code block format is incorrect, please manually copy the generated code.")
    return codeln
  end

  vim.api.nvim_set_hl(0, "LLMSuggestCode", { fg = "#6aa84f", bg = "NONE" })
  vim.api.nvim_set_hl(0, "LLMSeparator", { fg = "#6aa84f", bg = "#333333" })

  for _, v in ipairs({ "raw", "separator", "llm" }) do
    extmark[v] = vim.api.nvim_create_namespace(v)
    local text = v == "raw" and "<<<<<<< " .. v .. space_text
      or v == "separator" and "======= " .. space_text
      or ">>>>>>> " .. v .. space_text
    extmark_opts[v] = {
      virt_text = { { text, "LLMSeparator" } },
      virt_text_pos = "overlay",
    }
  end

  extmark["code"] = vim.api.nvim_create_namespace("code")
  extmark_opts["code"] = {}
  mark_id["code"] = {}

  if offset ~= 0 then
    -- create line to display raw separator virtual text
    InsertTextLine(bufnr, 0, "")
  end

  mark_id["raw"] = vim.api.nvim_buf_set_extmark(bufnr, extmark.raw, start_line - 2 + offset, 0, extmark_opts.raw)

  -- create line to display the separator virtual text
  InsertTextLine(bufnr, end_line + offset, "")
  mark_id["separator"] =
    vim.api.nvim_buf_set_extmark(bufnr, extmark.separator, end_line + offset, 0, extmark_opts.separator)

  for l in res:gmatch("[^\r\n]+") do
    -- create line to display the code suggested by the LLM
    InsertTextLine(bufnr, end_line + codeln + 1 + offset, "")
    extmark_opts.code[codeln] = { virt_text = { { l, "LLMSuggestCode" } }, virt_text_pos = "overlay" }
    mark_id.code[codeln] =
      vim.api.nvim_buf_set_extmark(bufnr, extmark.code, end_line + codeln + 1 + offset, 0, extmark_opts.code[codeln])
    codeln = codeln + 1
  end

  -- create line to display LLM separator virtual text
  InsertTextLine(bufnr, end_line + codeln + 1 + offset, "")
  mark_id["llm"] = vim.api.nvim_buf_set_extmark(bufnr, extmark.llm, end_line + codeln + 1 + offset, 0, extmark_opts.llm)
  return codeln
end

local optim_code_with_diff_handler = function(name, F, state, streaming)
  local prompt = [[优化代码, 修改语法错误, 让代码更简洁, 增强可复用性，

给出优化思路和优化后的完整代码。 输出的代码块用# BEGINCODE 和 # ENDCODE 标记

优化后的代码缩进要和原来的代码缩进保持一致，下面是一个例子：

原代码为:
<space><space><space><space>def func(a, b)
<space><space><space><space><space><space><space><space>return a + b

输出结果为：

优化思路：
1. 函数名func不够明确，根据上下文判断该函数是要实现两数相加的功能，所以将函数名改为add
2. 函数定义的语法有问题，应以:结尾，应该是def add(a, b):

因为原代码整体缩进了N个空格，所以优化后的代码也缩进N个空格

优化后的代码为
```<language>
# BEGINCODE
<space><space><space><space>def add(a, b):
<space><space><space><space><space><space><space><space>return a + b
# ENDCODE
```

请按照格式，帮我优化这段代码：]]
  local start_line, end_line = F.GetVisualSelectionRange()
  local bufnr = vim.api.nvim_get_current_buf()
  local source_content = F.GetVisualSelection()

  -- local preview_box = CreatePopup("", true, { border = { style = "solid" }, enter = true })
  local preview_box = Popup({
    enter = true,
    border = "solid",
    win_options = { winblend = 0, winhighlight = "Normal:Normal" },
  })

  local layout = CreateLayout(
    "30%",
    "98%",
    Layout.Box({
      Layout.Box(preview_box, { size = "100%" }),
    }, { dir = "row" }),
    {
      position = {
        row = "50%",
        col = "100%",
      },
    }
  )

  layout:mount()

  local mark_id = {}
  local extmark = {}
  local extmark_opts = {}
  local space_text = string.rep(" ", vim.o.columns - 7)
  local start_str = "# BEGINCODE"
  local end_str = "# ENDCODE"
  local codeln = 0
  local offset = start_line == 1 and 1 or 0

  SetBoxOpts({ preview_box }, {
    filetype = { "markdown" },
    buftype = "nofile",
    spell = false,
    number = false,
    wrap = true,
    linebreak = false,
  })

  state.app["session"][name] = {}
  table.insert(state.app.session[name], { role = "user", content = prompt .. "\n" .. source_content })

  state.popwin = preview_box
  local worker = streaming(
    preview_box.bufnr,
    preview_box.winid,
    state.app.session[name],
    nil,
    nil,
    nil,
    nil,
    function(ostr)
      codeln = ShowDiff(
        bufnr,
        start_str,
        end_str,
        mark_id,
        extmark,
        extmark_opts,
        space_text,
        start_line,
        end_line,
        codeln,
        offset,
        ostr
      )
    end
  )

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
      vim.wait(200, function() end)
      worker.job = nil
    end
    if codeln ~= 0 then
      vim.api.nvim_buf_del_extmark(bufnr, extmark.raw, mark_id.raw)
      vim.api.nvim_buf_del_extmark(bufnr, extmark.separator, mark_id.separator)
      vim.api.nvim_buf_del_extmark(bufnr, extmark.llm, mark_id.llm)
      for i = 0, codeln - 1 do
        vim.api.nvim_buf_del_extmark(bufnr, extmark.code, mark_id.code[i])
      end

      -- remove the line created to display the code suggested by LLM.
      RemoveTextLines(bufnr, end_line + offset, end_line + codeln + 2 + offset)
      if offset ~= 0 then
        -- remove the line created to display the raw separator.
        RemoveTextLines(bufnr, 0, 1)
      end
    end
    layout:unmount()
  end)

  preview_box:map("n", { "Y", "y" }, function()
    if codeln ~= 0 then
      vim.api.nvim_buf_del_extmark(bufnr, extmark.raw, mark_id.raw)
      vim.api.nvim_buf_del_extmark(bufnr, extmark.separator, mark_id.separator)
      vim.api.nvim_buf_del_extmark(bufnr, extmark.llm, mark_id.llm)

      -- remove the line created to display the LLM separator.
      RemoveTextLines(bufnr, end_line + codeln + 1 + offset, end_line + codeln + 2 + offset)
      -- remove raw code
      RemoveTextLines(bufnr, start_line - 1, end_line + 1 + offset)

      for i = 0, codeln - 1 do
        vim.api.nvim_buf_del_extmark(bufnr, extmark.code, mark_id.code[i])
      end

      for i = 0, codeln - 1 do
        -- Write the code suggested by the LLM.
        ReplaceTextLine(bufnr, start_line - 1 + i, extmark_opts.code[i].virt_text[1][1])
      end
    end
    layout:unmount()
  end)
end

local optimize_code_handler = function(name, F, state, streaming)
  local ft = vim.bo.filetype
  local prompt = [[优化代码, 修改语法错误, 让代码更简洁, 增强可复用性，
            你要像copliot那样，直接给出代码内容, 不要使用代码块或其他标签包裹!

            下面是一个例子，假设我们需要优化下面这段代码:
            void test() {
             return 0
            }

            输出格式应该为：
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
      vim.wait(200, function() end)
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
  local prompt = [[请帮我把这段话翻译成英语, 直接给出翻译结果: ]]

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
  vim.api.nvim_command("startinsert")

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
    -- clear preview_box content [optional]
    vim.api.nvim_buf_set_lines(preview_box.bufnr, 0, -1, false, {})

    local input_table = vim.api.nvim_buf_get_lines(input_box.bufnr, 0, -1, true)
    local input = table.concat(input_table, "\n")

    -- clear input_box content
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
        vim.wait(200, function() end)
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
        -- cloudflared
        -- model = "@cf/qwen/qwen1.5-14b-chat-awq",

        -- GLM
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        max_tokens = 8000,

        -- kimi
        -- url = "https://api.moonshot.cn/v1/chat/completions",
        -- model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
        -- streaming_handler = kimi_handler,
        -- max_tokens = 4096,

        url = "https://models.inference.ai.azure.com/chat/completions",
        model = "gpt-4o",
        streaming_handler = kimi_handler,
        max_tokens = 4096,

        temperature = 0.3,
        top_p = 0.7,

        prompt = "You are a helpful assistant.",
        -- prompt = [[
        -- ## Role:
        -- You are an erudite and intelligent programming expert who is eager to answer others' questions.
        --
        -- -----------------------
        --
        -- ## Skills:
        -- 1. When someone asks you a question, you are generous with your own answers and usually include your code examples.
        -- 2. If there are some questions that you are not certain about, you will search the internet for the answers. You will only present the compiled answers to others when you believe they are reliable, along with your references.
        --
        -- -----------------------
        --
        -- ## Requirements:
        -- 1. Answer others' questions honestly and never fabricate false information!
        -- 2. Think step by step and clearly explain your code examples.
        -- ]],

        prefix = {
          user = { text = "😃 ", hl = "Title" }, -- 
          assistant = { text = "  ", hl = "Added" },
        },

        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        -- stylua: ignore
        -- popup window options
        popwin_opts = {
          relative = "cursor",
          position = { row = -7, col = 15, },
          size = { height = 15, width = "50%", },
          enter = true,
          focusable = true,
          zindex = 50,
          border = { style = "rounded",
            text = { top = " Explain ", top_align = "center" },
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

        app_handler = {
          -- OptimizeCode = optimize_code_handler,
          OptimizeCode = optim_code_with_diff_handler,
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
