local luasnip = require("luasnip")

luasnip.setup({
  history = true,
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
