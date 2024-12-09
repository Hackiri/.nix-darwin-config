return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      -- Disable default bindings
      vim.g.codeium_disable_bindings = 1
    end,
    keys = {
      {
        "i",
        "<Tab>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        expr = true,
        silent = true,
        desc = "Accept Codeium suggestion",
      },
      {
        "i",
        "<C-;>",
        function()
          return vim.fn["codeium#CycleCompletions"](1)
        end,
        expr = true,
        desc = "Next Codeium suggestion",
      },
      {
        "i",
        "<C-,>",
        function()
          return vim.fn["codeium#CycleCompletions"](-1)
        end,
        expr = true,
        desc = "Previous Codeium suggestion",
      },
      {
        "i",
        "<C-x>",
        function()
          return vim.fn["codeium#Clear"]()
        end,
        expr = true,
        desc = "Clear Codeium suggestion",
      },
    },
  },
}
