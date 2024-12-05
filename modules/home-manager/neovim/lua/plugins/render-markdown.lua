-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "lukas-reineke/headlines.nvim", -- For better markdown headings
    "epwalsh/obsidian.nvim", -- For Obsidian integration
  },
  config = function()
    require("render-markdown").setup({
      latex = {
        enabled = true,
      },
    })
  end,
}
