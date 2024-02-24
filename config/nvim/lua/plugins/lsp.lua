-- local utils = require("astronvim.utils")
return {
  { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "volar", "bashls", "svelte" })
  --   end,
  -- },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "js", "bash" })
  --   end,
  -- },
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   enabled = false,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       utils.list_insert_unique(opts.ensure_installed, { "shellcheck", "shfmt", "stylua", "astyle", "nixfmt" })
  --   end,
  -- },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   enabled = false,
  --   config = function()
  --     local null_ls = require("null-ls")
  --
  --     -- register any number of sources simultaneously
  --     local sources = {
  --       null_ls.builtins.formatting.prettierd.with({
  --         extra_filetypes = { "svelte" },
  --       }),
  --       null_ls.builtins.formatting.eslint_d.with({
  --         extra_filetypes = { "svelte" },
  --       }),
  --       null_ls.builtins.formatting.astyle,
  --       null_ls.builtins.formatting.nixfmt,
  --     }
  --
  --     null_ls.setup({ sources = sources, on_attach = require("astronvim.utils.lsp").on_attach })
  --   end,
  -- },
  "b0o/SchemaStore.nvim",
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cond = function() return not vim.opt.diff:get() end,
    config = function()
      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config

      local capabilities = vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      lsp_defaults.capabilities = capabilities

      lspconfig.lua_ls.setup({})
      lspconfig.nil_ls.setup({})

      lspconfig.arduino_language_server.setup({})

      lspconfig.taplo.setup({})

      lspconfig.pyright.setup({})
      lspconfig.ruff_lsp.setup({
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })

      lspconfig.gopls.setup({
        function(client)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
      })

      lspconfig.biome.setup({})
      lspconfig.tsserver.setup({})

      lspconfig.tailwindcss.setup({})
      lspconfig.cssls.setup({})

      lspconfig.html.setup({})

      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    cond = function() return not vim.opt.diff:get() end,
    main = "lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local function list_insert_unique(lst, vals)
        if not lst then lst = {} end
        assert(vim.tbl_islist(lst), "Provided table is not a list like table")
        if not vim.tbl_islist(vals) then vals = { vals } end
        local added = {}
        vim.tbl_map(function(v) added[v] = true end, lst)
        for _, val in ipairs(vals) do
          if not added[val] then
            table.insert(lst, val)
            added[val] = true
          end
        end
        return lst
      end

      lint.linters_by_ft = {
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        -- json = { "eslint_d" },
        -- jsonc = { "eslint_d" },
        -- svelte = { "eslint_d" },

        sh = { "shellcheck" },
        bash = { "shellcheck" },

        zsh = { "zsh" },

        ["*"] = { "codespell" },
      }

      local function linter()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local ft = vim.bo.filetype
        if ft ~= "neo-tree" and ft ~= "undotree" and ft ~= "diff" and ft ~= "alpha" then
          local names = lint._resolve_linter_by_ft(ft)

          -- Add fallback linters.
          if #names == 0 then list_insert_unique(names, lint.linters_by_ft["_"] or {}) end

          -- Add global linters.
          list_insert_unique(names, lint.linters_by_ft["*"] or {})

          -- Filter out linters that don't exist or don't match the condition.
          -- local ctx = { filename = vim.api.nvim_buf_get_name(0) }
          -- ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

          -- Run linters.
          if #names > 0 then lint.try_lint(names) end
        end
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = linter,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        -- svelte = { { "prettier", "prettierd" }, "rustywind" },
        -- css = { { "prettier", "prettierd" }, "rustywind" },
        -- html = { { "prettier", "prettierd" }, "rustywind" },
        -- yaml = { { "prettier", "prettierd" } },
        -- markdown = { { "prettier", "prettierd" } },
        -- graphql = { { "prettier", "prettierd" } },

        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        lua = { "stylua" },
        nix = { "nixfmt" },
        arduino = { "astyle" },
        toml = { "taplo" },
        go = { "goimports", "gofumpt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        quiet = true,
        timeout_ms = 500,
      },
      formatters = {
        nixfmt = { prepend_args = { "-w", "120" } },
        stylua = { prepend_args = { "--indent-type", "spaces", "--indent-width", "2", "--column-width", "999", "--collapse-simple-statement", "Always" } },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<leader>x", desc = "Trouble" },
      { "<leader>x" .. "X", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>x" .. "x", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>x" .. "l", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>x" .. "q", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {
      use_diagnostic_signs = true,
      action_keys = { close = { "q", "<esc>" }, cancel = "<c-e>" },
    },
  },
  {
    "stevearc/aerial.nvim",
    event = "User File",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
  },
}
