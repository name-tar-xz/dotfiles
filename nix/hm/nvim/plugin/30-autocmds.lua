vim.schedule(function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
      vim.lsp.inlay_hint.enable(true)

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method("textDocument/codeLens") then
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = args.buf,
          callback = vim.lsp.codelens.refresh,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(args)
      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
        id = "lsp_progress",
        title = "LSP Progress",
        opts = function(notif) notif.icon = args.data.params.value.kind == "end" and " " or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
      })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
    pattern = vim
      .iter(vim.api.nvim_get_runtime_file("parser/*.so", true))
      :map(function(v) return vim.treesitter.language.get_filetypes(v:match("([^/]+)%.so$")) end)
      :flatten()
      :totable(),
    callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"

      require("treesitter-context").setup({ max_lines = 3 })

      vim.keymap.set({ "n", "x", "o" }, "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[M", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "]p", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]P", function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[p", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[P", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.inner", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "]z", function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end)
      vim.keymap.set({ "n", "x", "o" }, "]Z", function() require("nvim-treesitter-textobjects.move").goto_next_end("@fold", "folds") end)
      vim.keymap.set({ "n", "x", "o" }, "[z", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds") end)
      vim.keymap.set({ "n", "x", "o" }, "[Z", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@fold", "folds") end)
    end,
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("diagnostic", { clear = true }),
    callback = function() vim.diagnostic.open_float({ scope = "cursor", focusable = false }) end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
      "checkhealth",
      "help",
      "notify",
      "nvim-undotree",
      "qf",
      "tsplayground",
    },
    callback = function(args)
      vim.bo[args.buf].buflisted = false
      vim.schedule(function()
        vim.keymap.set("n", "q", function()
          vim.cmd("close")
          pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
        end, {
          buffer = args.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end)
    end,
  })
end)
