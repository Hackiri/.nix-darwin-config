-- NeoBean highlights configuration

-- Safe require function to handle missing modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Error loading module: " .. module .. "\n" .. result, vim.log.levels.WARN)
    return {}
  end
  return result
end

-- Require the colors.lua module and access the colors directly without
-- additional file reads
local colors = safe_require("config.colors")

-- Default colors in case the custom colors are not available
local default_colors = {
  color01 = "#e06c75", -- Red
  color02 = "#98c379", -- Green
  color03 = "#e5c07b", -- Yellow
  color04 = "#61afef", -- Blue
  color05 = "#c678dd", -- Purple
  color08 = "#56b6c2", -- Cyan
  color13 = "#abb2bf", -- Light gray
  color26 = "#282c34", -- Dark background
}

-- Helper function to get color with fallback
local function get_color(name)
  return colors[name] or default_colors[name] or "#ffffff"
end

-- Get colors with fallbacks
local color1_bg = get_color("color04") -- Blue
local color2_bg = get_color("color02") -- Green
local color3_bg = get_color("color03") -- Yellow
local color4_bg = get_color("color01") -- Red
local color5_bg = get_color("color05") -- Purple
local color6_bg = get_color("color08") -- Cyan
local color_fg = get_color("color13") -- Light gray

-- Safe highlight setting function
local function safe_highlight(group, settings)
  local ok, err = pcall(vim.cmd, settings)
  if not ok then
    vim.notify("Error setting highlight for " .. group .. ": " .. err, vim.log.levels.WARN)
  end
end

-- Set highlights based on background style
if vim.g.md_heading_bg == "transparent" then
  safe_highlight(
    "@markup.heading.1.markdown",
    string.format([[highlight @markup.heading.1.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color1_bg)
  )
  safe_highlight(
    "@markup.heading.2.markdown",
    string.format([[highlight @markup.heading.2.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color2_bg)
  )
  safe_highlight(
    "@markup.heading.3.markdown",
    string.format([[highlight @markup.heading.3.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color3_bg)
  )
  safe_highlight(
    "@markup.heading.4.markdown",
    string.format([[highlight @markup.heading.4.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color4_bg)
  )
  safe_highlight(
    "@markup.heading.5.markdown",
    string.format([[highlight @markup.heading.5.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color5_bg)
  )
  safe_highlight(
    "@markup.heading.6.markdown",
    string.format([[highlight @markup.heading.6.markdown cterm=bold gui=bold guibg=%s guifg=%s]], color_fg, color6_bg)
  )
else
  color_fg = get_color("color26") -- Dark background
  safe_highlight(
    "@markup.heading.1.markdown",
    string.format([[highlight @markup.heading.1.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color1_bg)
  )
  safe_highlight(
    "@markup.heading.2.markdown",
    string.format([[highlight @markup.heading.2.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color2_bg)
  )
  safe_highlight(
    "@markup.heading.3.markdown",
    string.format([[highlight @markup.heading.3.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color3_bg)
  )
  safe_highlight(
    "@markup.heading.4.markdown",
    string.format([[highlight @markup.heading.4.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color4_bg)
  )
  safe_highlight(
    "@markup.heading.5.markdown",
    string.format([[highlight @markup.heading.5.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color5_bg)
  )
  safe_highlight(
    "@markup.heading.6.markdown",
    string.format([[highlight @markup.heading.6.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color6_bg)
  )
end
