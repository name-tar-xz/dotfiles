vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  group = vim.api.nvim_create_augroup("lint-format", { clear = true }),
  callback = function()
    if not vim.o.diff then
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "zsh" },
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          local ft = vim.bo.filetype
          if ft ~= "trouble" and ft ~= "undotree" and ft ~= "diff" then
            require("lint").try_lint()
          end
        end,
      })
    end

    require("conform").setup({
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        nix = { "nixfmt" },

        lua = { "stylua" },
        arduino = { "astyle" },
        toml = { "taplo" },
        go = { "goimports", "gofumpt" },

        ["_"] = { lsp_format = "prefer" },
        ["*"] = { "injected" },
      },

      default_format_opts = {
        lsp_format = "fallback",
        async = true,
        quiet = true,
      },

      format_on_save = {
        async = false,
        quiet = true,
        timeout_ms = 500,
      },
    })
  end,
})
