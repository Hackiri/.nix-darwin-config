return {
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  ft = { "markdown", "norg", "rmd", "org" },
  config = function()
    require("headlines").setup({
      markdown = {
        headline_highlights = {
          "Headline1",
          "Headline2",
          "Headline3",
          "Headline4",
          "Headline5",
          "Headline6",
        },
        fat_headlines = false, -- Disable fat headlines to avoid conflicts
        fat_headline_upper_string = "",
        fat_headline_lower_string = "",
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "─",
        quote_highlight = "Quote",
        quote_string = "┃",
        bullets = {
          "•",
          "◦",
          "○", -- Bullet points for lists
        },
      },
    })
  end,
}
