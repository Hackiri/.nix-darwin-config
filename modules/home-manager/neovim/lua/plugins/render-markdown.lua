-- https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    -- Define colors to match Tokyo Night theme
    local colors = {
      -- Heading background colors (from light to dark)
      -- Using a mix of normal and bright colors from your theme
      color18 = "#363b54", -- Base background
      color19 = "#515c7e", -- Selection color
      color20 = "#3d59a1", -- Search match color
      color21 = "#7aa2f7", -- Blue
      color22 = "#7dcfff", -- Cyan
      color23 = "#bb9af7", -- Magenta
      -- Text color
      color10 = "#acb0d0", -- Bright white for better contrast
    }

    -- Define color variables
    local color1_bg = colors["color18"]
    local color2_bg = colors["color19"]
    local color3_bg = colors["color20"]
    local color4_bg = colors["color21"]
    local color5_bg = colors["color22"]
    local color6_bg = colors["color23"]
    local color_fg = colors["color10"]

    -- Heading colors (when not hovered over), extends through the entire line
    vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
    vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
    vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
    vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
    vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
    vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))

    -- Highlight for the heading and sign icons
    vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
    vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
    vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
    vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
    vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
    vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
  end,
  opts = {
    bullet = {
      enabled = true, -- Enable list bullet rendering
    },
    checkbox = {
      enabled = true, -- Enable checkbox state rendering
      position = "inline", -- 'inline' for left-aligned icons
      unchecked = {
        icon = "   󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },
      checked = {
        icon = "   󰱒 ",
        highlight = "RenderMarkdownChecked",
        scope_highlight = nil,
      },
    },
    heading = {
      sign = false, -- Disable sign column icons
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      backgrounds = {
        "Headline1Bg",
        "Headline2Bg",
        "Headline3Bg",
        "Headline4Bg",
        "Headline5Bg",
        "Headline6Bg",
      },
      foregrounds = {
        "Headline1Fg",
        "Headline2Fg",
        "Headline3Fg",
        "Headline4Fg",
        "Headline5Fg",
        "Headline6Fg",
      },
    },
    latex = {
      enabled = false, -- Disable LaTeX rendering
    },
  },
}
