vim.schedule(function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
      vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
      vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
      vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
      vim.keymap.set("n", "gri", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
      vim.keymap.set("n", "grt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto Type Definition" })
      vim.keymap.set("n", "grN", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
      vim.keymap.set("n", "gO", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })

      vim.lsp.inlay_hint.enable(true)
      vim.lsp.codelens.enable(true)
      vim.lsp.on_type_formatting.enable()
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

  local linenr_grp = vim.api.nvim_create_augroup("linenr", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    group = linenr_grp,
    desc = "Toggle relative line numbers on",
    callback = function()
      if vim.wo.number then vim.wo.relativenumber = true end
    end,
  })
  vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    group = linenr_grp,
    desc = "Toggle relative line numbers off",
    callback = function()
      if vim.wo.number then vim.wo.relativenumber = false end
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
