return {
  -- tools
  {
    "williamboman/mason.nvim",
    keys = {
      {
        "<leader>gG",
        function()
          LazyVim.terminal.open({ "gitui" }, { esc_esc = false, ctrl_hjkl = false })
        end,
        desc = "GitUi (cwd)",
      },
      {
        "<leader>gg",
        function()
          LazyVim.terminal.open({ "gitui" }, { cwd = LazyVim.root.get(), esc_esc = false, ctrl_hjkl = false })
        end,
        desc = "GitUi (Root Dir)",
      },
    },
    init = function()
      -- delete lazygit keymap for file history
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimKeymaps",
        once = true,
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>gf")
        end,
      })
    end,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gitui",
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "tailwindcss-language-server",
        "typescript-language-server",
        "python-lsp-server",
        "css-lsp",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
    end,
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "?",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {},
      servers = {
        tsserver = {
          root_dir = function(...)
            return require("lspconfig").util.root_pattern("package.json")(...)
          end,
          single_file_support = false,
          settings = {},
        },
      },
    },
    setup = {},
  },
}
