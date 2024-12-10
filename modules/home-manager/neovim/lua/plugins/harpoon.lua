return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ma",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Add mark",
    },
    {
      "<leader>mm",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Show marks",
    },
    {
      "<leader>m1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Jump to mark 1",
    },
    {
      "<leader>m2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Jump to mark 2",
    },
    {
      "<leader>m3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Jump to mark 3",
    },
    {
      "<leader>m4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Jump to mark 4",
    },
    {
      "<leader>mp",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Previous mark",
    },
    {
      "<leader>mn",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Next mark",
    },
  },
  config = function()
    require("harpoon"):setup({})
  end,
}
