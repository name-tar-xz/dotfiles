vim.api.nvim_create_autocmd("BufReadPre", {
  once = true,
  callback = function() require("treesitter-context").setup({ max_lines = 3 }) end,
})
