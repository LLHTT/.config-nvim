return {
  -- blamer
  { "APZelos/blamer.nvim" },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "kyazdani42/nvim-web-devicons", opt = true },
      { "kdheepak/tabline.nvim" },
    },
    config = function()
      local lualine = require("lualine")
      local tabline = require("tabline")

      tabline.setup({ enable = false })

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "NeoSolarized",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "NvimTree" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            {
              "filename",
              file_status = true, -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 1, -- 0: Just the filename
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory

              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              -- for other components. (terrible name, any suggestions?)
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
            },
          },
          lualine_x = { "filetype" },
          lualine_y = {},
          lualine_z = { "progress" },
        },
        inactive_sections = {},
        tabline = {
          lualine_a = { "buffers" },
          lualine_b = { "branch" },
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "tabs" },
        },
        extensions = { "fugitive", "nvim-tree" },
      })
    end,
  },

  -- tabline
  -- { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  -- notify
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<leader>fk", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<leader>fj", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
    },
  },

  -- filename
  {
    "b0o/incline.nvim",
    -- dependencies = { "Mofiqul/vscode.nvim" },
    dependencies = { "Tsuzat/NeoSolarized.nvim" },
    event = "VeryLazy",
    priority = 1200,
    config = function()
      local devicons = require("nvim-web-devicons")
      -- local colors = require("tokyonight.colors").setup()
      require("incline").setup({
        window = {
          margin = { vertical = 0, horizontal = 1 },
          placement = {
            horizontal = "right",
            vertical = "top",
          },
        },
        highlight = {
          groups = {
            -- InclineNormal = { guibg = colors.base03 },
            -- InclineNormalNC = { guifg = colors.dark3 },
          },
        },

        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":.") -- for full path
          -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t") -- for shorten path
          -- to display the last two segments of the path:
          -- local full_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:.")
          -- local filename = table.concat(vim.split(full_path, "/"), "/", #vim.split(full_path, "/") - 1) -- -2 for the last 3 segments
          if filename == "" then
            filename = "[No Name]"
          end
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          return {
            { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
            { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
            -- { "┊  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
          }
        end,
      })
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        -- gitsigns = true,
        tmux = true,
        -- kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  --   {
  --     "nvimdev/dashboard-nvim",
  --     event = "VimEnter",
  --     opts = function(_, opts)
  --       local logo = [[
  -- ███╗   ███╗ █████╗ ██████╗ ██╗   ██╗████████╗██╗
  -- ████╗ ████║██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██║
  -- ██╔████╔██║███████║██████╔╝██║   ██║   ██║   ██║
  -- ██║╚██╔╝██║██╔══██║██╔══██╗██║   ██║   ██║   ██║
  -- ██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╔╝   ██║   ██║
  -- ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝
  --       ]]
  --
  --       logo = string.rep("\n", 8) .. logo .. "\n\n"
  --       opts.config.header = vim.split(logo, "\n")
  --     end,
  --   },
}
