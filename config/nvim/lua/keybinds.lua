vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<C-q>", "<cmd>qa!<CR>", { desc = "Force quit" })

vim.keymap.set("n", "|", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<CR>", { desc = "Horizontal Split" })

vim.keymap.set("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "Lazy install" })
vim.keymap.set("n", "<leader>pp", "<cmd>Lazy profile<CR>", { desc = "Lazy profile" })
vim.keymap.set("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "Lazy update" })
vim.keymap.set("n", "<leader>px", "<cmd>Lazy clean<CR>", { desc = "Lazy clean" })
vim.keymap.set("n", "<leader>pS", "<cmd>Lazy sync<CR>", { desc = "Lazy sync" })
vim.keymap.set("n", "<leader>ps", "<cmd>Lazy show<CR>", { desc = "Lazy status" })
vim.keymap.set("n", "<leader>pp", "<cmd>Lazy profile<CR>", { desc = "Lazy Profile" })

-- Buffers
vim.keymap.set("n", "<leader>c", function() require("snacks").bufdelete() end, { desc = "Close buffer" })

-- GitSigns
vim.keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next Git hunk" })
vim.keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous Git hunk" })
vim.keymap.set("n", "<leader>gl", function() require("gitsigns").blame_line() end, { desc = "View Git blame" })
vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview Git hunk" })
vim.keymap.set("n", "<leader>gh", function() require("gitsigns").reset_hunk() end, { desc = "Reset Git hunk" })
vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_buffer() end, { desc = "Reset Git buffer" })
vim.keymap.set("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Git hunk" })
vim.keymap.set("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Unstage Git hunk" })
vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "View Git diff" })

-- LSP
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "LSP Diagnostics" })

vim.keymap.set("n", "<leader>lf", function() require("conform").format() end, { desc = "Format" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set({ "n", "v" }, "d", [["_d]])
vim.keymap.set({ "n", "v" }, "x", [["_x]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<Esc>", "<esc>:nohlsearch<CR>", { silent = true })

if vim.opt.scrolloff._value ~= 999 then
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "n", "nzz")
  vim.keymap.set("n", "N", "Nzz")
  vim.keymap.set("n", "i", "zzi")
  vim.keymap.set("n", "a", "zza")
  vim.keymap.set("n", "I", "zzI")
  vim.keymap.set("n", "A", "zzA")
  vim.keymap.set("n", "o", "zzo")
  vim.keymap.set("n", "O", "zzO")
end
