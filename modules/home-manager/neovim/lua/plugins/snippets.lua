return {
  "L3MON4D3/LuaSnip",
  lazy = true,  -- Let nvim-cmp load it
  config = function()
    local ls = require("luasnip")
    local snippet_dir = vim.fn.stdpath("config") .. "/snippets"

    -- Create directory for custom snippets if it doesn't exist
    if vim.fn.isdirectory(snippet_dir) == 0 then
      vim.fn.mkdir(snippet_dir, "p")
    end

    -- Create markdown snippets file if it doesn't exist
    local markdown_snippets = snippet_dir .. "/markdown.lua"
    if vim.fn.filereadable(markdown_snippets) == 0 then
      local file = io.open(markdown_snippets, "w")
      if file then
        file:write([[
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Get clipboard contents
local function clipboard()
  return vim.fn.getreg("+")
end

return {
  -- Code blocks
  s("```", fmt("```{}\n{}\n```", { i(1, "language"), i(2) })),
  s("py", fmt("```python\n{}\n```", { i(1) })),
  s("js", fmt("```javascript\n{}\n```", { i(1) })),
  s("ts", fmt("```typescript\n{}\n```", { i(1) })),
  s("sh", fmt("```bash\n{}\n```", { i(1) })),
  s("lua", fmt("```lua\n{}\n```", { i(1) })),

  -- Links
  s("link", fmt("[{}]({})", { i(1, "text"), i(2, "url") })),
  s("linkt", fmt("[{}]({}){{:target=\"_blank\"}}", { i(1, "text"), i(2, "url") })),
  s("linkclip", fmt("[{}]({})", { i(1, "text"), f(clipboard, {}) })),

  -- Headers
  s("h1", fmt("# {}", { i(1) })),
  s("h2", fmt("## {}", { i(1) })),
  s("h3", fmt("### {}", { i(1) })),

  -- Lists
  s("ul", fmt("- {}", { i(1) })),
  s("ol", fmt("1. {}", { i(1) })),
  s("cl", fmt("- [ ] {}", { i(1) })),

  -- Tables
  s("table2", fmt([[
| {} | {} |
|---|---|
| {} | {} |
]], {
    i(1, "Header 1"),
    i(2, "Header 2"),
    i(3, "Row 1"),
    i(4, "Row 1"),
  })),

  -- Callouts
  s("note", fmt("> **Note**\n> {}", { i(1) })),
  s("warn", fmt("> **Warning**\n> {}", { i(1) })),
  s("info", fmt("> **Info**\n> {}", { i(1) })),

  -- Images
  s("img", fmt("![{}]({})", { i(1, "alt text"), i(2, "url") })),
  s("imgclip", fmt("![{}]({})", { i(1, "alt text"), f(clipboard, {}) })),

  -- Comments and metadata
  s("todo", fmt("<!-- TODO: {} -->", { i(1) })),
  s("meta", fmt([[
---
title: {}
date: {}
tags: [{}]
---

{}]], {
    i(1, "Title"),
    f(function() return os.date("%Y-%m-%d") end),
    i(2, "tag1, tag2"),
    i(0),
  })),
}
]])
        file:close()
      end
    end

    -- Create general snippets file if it doesn't exist
    local general_snippets = snippet_dir .. "/all.lua"
    if vim.fn.filereadable(general_snippets) == 0 then
      local file = io.open(general_snippets, "w")
      if file then
        file:write([[
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Comments
  s("todo", fmt("// TODO: {}", { i(1) })),
  s("fix", fmt("// FIXME: {}", { i(1) })),
  s("hack", fmt("// HACK: {}", { i(1) })),
  s("note", fmt("// NOTE: {}", { i(1) })),
}
]])
        file:close()
      end
    end
  end,
}
