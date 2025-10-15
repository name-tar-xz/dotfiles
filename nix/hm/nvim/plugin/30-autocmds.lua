vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function() vim.lsp.inlay_hint.enable(true) end,
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
    vim.o.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.o.foldmethod = "expr"
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("diagnostic", { clear = true }),
  callback = function() vim.diagnostic.open_float({ scope = "cursor", focus_id = "no" }) end,
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
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})
