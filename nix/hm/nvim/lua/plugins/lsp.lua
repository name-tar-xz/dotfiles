return {
  {
    "mfussenegger/nvim-lint",
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
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        nix = { "nixfmt" },

        lua = { "stylua" },
        arduino = { "astyle" },
        toml = { "taplo" },
        go = { "goimports", "gofumpt" },
        ["*"] = { "injected" },
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
    "folke/trouble.nvim",
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
