return {
  "leath-dub/snipe.nvim",
  lazy = false,
  keys = {
    {
      "<leader>mf",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
  config = function()
    local snipe = require("snipe")

    -- Setup UI select menu
    snipe.ui_select_menu = require("snipe.menu"):new({ position = "center" })
    snipe.ui_select_menu:add_new_buffer_callback(function(m)
      vim.keymap.set("n", "<esc>", function()
        m:close()
      end, { nowait = true, buffer = m.buf })
    end)
    vim.ui.select = snipe.ui_select

    -- Basic configuration
    snipe.setup({
      hints = {
        dictionary = "asfghl;wertyuiop",
      },
      navigate = {
        cancel_snipe = "<esc>",
        close_buffer = "d",
      },
      sort = "default",
    })
  end,
}
