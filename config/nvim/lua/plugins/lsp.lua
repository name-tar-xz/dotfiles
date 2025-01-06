return {
  {
    "neovim/nvim-lspconfig",
    dir = P.lspconfig,
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.opt.diff:get(),
    config = function()
      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config

      local capabilities = require("blink.cmp").get_lsp_capabilities(lsp_defaults.capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lsp_defaults.capabilities = capabilities

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
            nixpkgs = {
              expr = "import <nixpkgs> {}",
            },
            options = {
              home_manager = {
                expr = '(builtins.getFlake "/home/tarxz/.config/nixos").nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []',
              },
            },
          },
        },
      })

      lspconfig.arduino_language_server.setup({})

      lspconfig.taplo.setup({})

      lspconfig.pyright.setup({})
      lspconfig.ruff.setup({
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
      formatters = {
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      },
    },
  },
  {
    "folke/trouble.nvim",
    dir = P.trouble,
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
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
}
