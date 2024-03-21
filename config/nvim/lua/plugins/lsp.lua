return {
  "b0o/SchemaStore.nvim",
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.opt.diff:get(),
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

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            hint = {
              enable = true,
            },
          },
        },
      })

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

      lspconfig.biome.setup({ single_file_support = true })
      lspconfig.tsserver.setup({
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            importModuleSpecifierPreference = "non-relative",
          },
        },
      })

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
        if not lst then
          lst = {}
        end
        assert(vim.tbl_islist(lst), "Provided table is not a list like table")
        if not vim.tbl_islist(vals) then
          vals = { vals }
        end
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
          if #names == 0 then
            list_insert_unique(names, lint.linters_by_ft["_"] or {})
          end

          -- Add global linters.
          list_insert_unique(names, lint.linters_by_ft["*"] or {})

          -- Filter out linters that don't exist or don't match the condition.
          -- local ctx = { filename = vim.api.nvim_buf_get_name(0) }
          -- ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

          -- Run linters.
          if #names > 0 then
            lint.try_lint(names)
          end
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
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
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
