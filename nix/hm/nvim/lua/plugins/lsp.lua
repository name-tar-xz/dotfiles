return {
  {
    "neovim/nvim-lspconfig",
    dir = P.lspconfig,
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.o.diff,
    config = function()
      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config

      lsp_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lsp_defaults.capabilities)

      lspconfig.typos_lsp.setup({
        init_options = {
          diagnosticSeverity = "Hint",
        },
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      })

      lspconfig.nixd.setup({
        settings = {
          nixd = {
            nixpkgs = { expr = '(builtins.getFlake "/home/tarxz/.config/nixos").nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []' },
            options = { home_manager = { expr = '(builtins.getFlake "/home/tarxz/.config/nixos").nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []' } },
          },
        },
      })

      lspconfig.arduino_language_server.setup({})

      lspconfig.taplo.setup({})

      lspconfig.pyright.setup({})
      lspconfig.ruff.setup({ on_attach = function(client) client.server_capabilities.hoverProvider = false end })

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

      lspconfig.vtsls.setup({
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      })

      lspconfig.tailwindcss.setup({})
      lspconfig.cssls.setup({})

      lspconfig.html.setup({})

      lspconfig.jsonls.setup({})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    dir = P.lint,
    cond = not vim.o.diff,
    main = "lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local function list_insert_unique(lst, vals)
        if not lst then
          lst = {}
        end
        assert(vim.islist(lst), "Provided table is not a list like table")
        if not vim.islist(vals) then
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
      }

      local function linter()
        local ft = vim.bo.filetype
        if ft ~= "trouble" and ft ~= "undotree" and ft ~= "diff" then
          local names = lint._resolve_linter_by_ft(ft)

          -- Add fallback linters.
          if #names == 0 then
            list_insert_unique(names, lint.linters_by_ft["_"] or {})
          end

          -- Add global linters.
          list_insert_unique(names, lint.linters_by_ft["*"] or {})

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
    dir = P.conform,
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
        nix = { "nixfmt" },

        lua = { "stylua" },
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
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    dir = P.tiny_inline_diagnostic,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        use_icons_from_diagnostic = true,
        multilines = true,
      },
    },
  },
  {
    "folke/trouble.nvim",
    dir = P.trouble,
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ..." },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
    opts = {
      use_diagnostic_signs = true,
      multiple_diag_under_cursor = true,
      action_keys = { close = { "q", "<esc>" }, cancel = "<c-e>" },
    },
  },
}
