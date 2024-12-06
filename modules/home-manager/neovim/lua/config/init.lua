-- lua/config/init.lua

-- Load core configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.session")
require("config.snippets")
require("config.luasnip_config")
require("config.highlights") -- Load custom highlights

-- Load folding (with error handling)
pcall(function()
  require("config.folding")
end)

require("config.lazy") -- This should be last
