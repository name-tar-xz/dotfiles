vim.schedule(function()
  vim.keymap.set("n", "]a", "<cmd>tabnext<CR>")
  vim.keymap.set("n", "]A", "<cmd>tablast<CR>")
  vim.keymap.set("n", "[a", "<cmd>tabprevious<CR>")
  vim.keymap.set("n", "[A", "<cmd>tabfirst<CR>")

  vim.keymap.set({ "n", "v", "o" }, ";", ":")
  vim.keymap.set({ "n", "v", "o" }, ":", ";")

  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
  vim.keymap.set("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
  vim.keymap.set("n", "<C-Q>", "<cmd>qa!<CR>", { desc = "Force quit" })

  vim.keymap.set("n", "|", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
  vim.keymap.set("n", "\\", "<cmd>split<CR>", { desc = "Horizontal Split" })

  -- Clipboard
  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])
  vim.keymap.set({ "n", "v" }, "x", [["_x]])

  vim.keymap.set("n", "Q", "<nop>")

  vim.keymap.set("n", "<Esc>", "<esc>:nohlsearch<CR>", { silent = true })

  if vim.o.scrolloff ~= 1e3 then
    vim.keymap.set("n", "<C-D>", "<C-D>zz")
    vim.keymap.set("n", "<C-U>", "<C-U>zz")
    vim.keymap.set("n", "n", "nzz")
    vim.keymap.set("n", "N", "Nzz")
    vim.keymap.set("n", "i", "zzi")
    vim.keymap.set("n", "a", "zza")
    vim.keymap.set("n", "I", "zzI")
    vim.keymap.set("n", "A", "zzA")
    vim.keymap.set("n", "o", "zzo")
    vim.keymap.set("n", "O", "zzO")
  end
end)
