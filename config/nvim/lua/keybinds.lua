vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>o", "<cmd>UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
vim.keymap.set("n", "<leader>O", "<cmd>UndotreeFocus<CR>", { desc = "Focus UndoTree" })

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
vim.keymap.set("n", "<leader>c", function() require("bufdelete").bufdelete(0, false) end, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>C", function() require("bufdelete").bufdelete(0, true) end, { desc = "Force close buffer" })
vim.keymap.set("n", ">b", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer tab right" })
vim.keymap.set("n", "<b", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer tab left" })

-- vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer tab" })
-- vim.keymap.set("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer tab" })
-- vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer tab" })
-- vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>", { desc = "Previous buffer tab" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move to right split" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", function() require("smart-splits").resize_up() end, { desc = "Resize split up" })
vim.keymap.set("n", "<C-Down>", function() require("smart-splits").resize_down() end, { desc = "Resize split down" })
vim.keymap.set("n", "<C-Left>", function() require("smart-splits").resize_left() end, { desc = "Resize split left" })
vim.keymap.set("n", "<C-Right>", function() require("smart-splits").resize_right() end, { desc = "Resize split right" })

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

-- Comment
vim.keymap.set("n", "<leader>/", "gcc", { desc = "Comment line", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "Comment line", remap = true })

-- Telescope
vim.keymap.set("n", "<leader>gC", function() require("telescope.builtin").git_bcommits({ use_file_path = true }) end, { desc = "Git commits (current file)" })
vim.keymap.set("n", "<leader>gb", function() require("telescope.builtin").git_branches() end, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", function() require("telescope.builtin").git_commits({ use_file_path = true }) end, { desc = "Git commits (repository)" })
vim.keymap.set("n", "<leader>gt", function() require("telescope.builtin").git_status() end, { desc = "Git status" })

vim.keymap.set("n", "<leader>f`", function() require("telescope.builtin").marks() end, { desc = "Find marks" })
vim.keymap.set("n", "<leader>f/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, { desc = "Find words in current buffer" })
vim.keymap.set("n", "<leader>f<CR>", function() require("telescope.builtin").resume() end, { desc = "Resume previous search" })
vim.keymap.set("n", "<leader>fC", function() require("telescope.builtin").commands() end, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fF", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end, { desc = "Find all files" })
vim.keymap.set("n", "<leader>fW", function() require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--no-ignore" } }) end, { desc = "Find words in all files" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fc", function() require("telescope.builtin").grep_string() end, { desc = "Find word under cursor" })
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Find help" })
vim.keymap.set("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fm", function() require("telescope.builtin").man_pages() end, { desc = "Find man" })
vim.keymap.set("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end, { desc = "Find history" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").registers() end, { desc = "Find registers" })
vim.keymap.set("n", "<leader>ft", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, { desc = "Find themes" })
vim.keymap.set("n", "<leader>fw", function() require("telescope.builtin").live_grep() end, { desc = "Find words" })

vim.keymap.set("n", "<leader>fs", function() require("telescope").extensions.aerial.aerial() end, { desc = "Find symbols" })
vim.keymap.set("n", "<leader>fu", function() require("telescope").extensions.undo.undo() end, { desc = "Find undos" })

-- LSP
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references({ reuse_win = true }) end, { desc = "Goto Refrences" })
vim.keymap.set("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gY", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })

vim.keymap.set("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Hover" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>lh", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end, { desc = "Toggle Inlay Hints" })
vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "LSP Diagnostics" })

vim.keymap.set("n", "<leader>lf", function() require("conform").format() end, { desc = "Format" })
vim.keymap.set("n", "<leader>ls", "<cmd>AerialToggle!<CR>", { desc = "Find symbols" })

-- UFO
vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end)
vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end) -- closeAllFolds == closeFoldsWith(0)

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
