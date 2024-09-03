-- return {
--   "Mofiqul/vscode.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = function()
--     return {
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       transparent = true, -- Enable this to disable setting the background color
--       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--       styles = {
--         -- Style to be applied to different syntax groups
--         -- Value is any valid attr-list value for `:help nvim_set_hl`
--         comments = { italic = true },
--         keywords = { italic = true, bold = false },
--         functions = { bold = false },
--         variables = { italic = true },
--         -- Background styles. Can be "dark", "transparent" or "normal"
--         sidebars = "dark", -- style for sidebars, see below
--         floats = "dark", -- style for floating windows
--       },
--       sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
--       day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
--       hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
--       dim_inactive = true, -- dims inactive windows
--       lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
--
--       --- You can override specific color groups to use other groups or a hex color
--       --- function will be called with a ColorScheme table
--       on_colors = function(colors) end,
--
--       --- You can override specific highlights to use other groups or a hex color
--       --- function will be called with a Highlights and ColorScheme table
--       on_highlights = function(highlights, colors) end,
--     }
--   end,
-- }

return {
  "Tsuzat/NeoSolarized.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      style = "dark", -- "dark" or "light"
      transparent = true, -- true/false; Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
      styles = {
        -- Style to be applied to different syntax groups
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
        string = { italic = true },
        underline = true, -- true/false; for global underline
        undercurl = true, -- true/false; for global undercurl
      },
      -- Add specific hightlight groups
      on_highlights = function(highlights, colors)
        -- highlights.Include.fg = colors.red -- Using `red` foreground for Includes
      end,
    }
  end,
}
