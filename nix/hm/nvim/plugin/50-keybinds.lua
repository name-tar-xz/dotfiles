vim.g.mapleader = vim.keycode("<Space>") -- Set <Space> as the <Leader> key
vim.g.maplocalleader = vim.keycode("<Space>")

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

-- LSP
vim.keymap.set("n", "grf", function() require("conform").format() end, { desc = "Format" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "x", [["_x]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<Esc>", "<esc>:nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "gS", function() require("treesj").toggle() end)

vim.keymap.set("n", "<leader>o", function() require("undotree").open() end)

vim.keymap.set("n", "<leader>e", function()
  if not require("mini.files").close() then
    require("mini.files").open()
  end
end, { desc = "Open mini.files" })

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

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

vim.keymap.set("n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" })
vim.keymap.set("n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" })
vim.keymap.set("n", "g<C-a>", function() return require("dial.map").inc_gnormal() end, { expr = true, desc = "Increment" })
vim.keymap.set("n", "g<C-x>", function() return require("dial.map").dec_gnormal() end, { expr = true, desc = "Decrement" })
vim.keymap.set("v", "<C-a>", function() return require("dial.map").inc_visual() end, { expr = true, desc = "Increment" })
vim.keymap.set("v", "<C-x>", function() return require("dial.map").dec_visual() end, { expr = true, desc = "Decrement" })
vim.keymap.set("v", "g<C-a>", function() return require("dial.map").inc_gvisual() end, { expr = true, desc = "Increment" })
vim.keymap.set("v", "g<C-x>", function() return require("dial.map").dec_gvisual() end, { expr = true, desc = "Decrement" })

vim.keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next Git hunk" })
vim.keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous Git hunk" })
vim.keymap.set("n", "<leader>gl", function() require("gitsigns").blame_line() end, { desc = "View Git blame" })
vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview Git hunk" })
vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_buffer() end, { desc = "Reset Git buffer" })
vim.keymap.set("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Unstage Git hunk" })
vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "View Git diff" })
vim.keymap.set({ "n", "v" }, "<leader>gh", ":Gitsigns reset_hunk<CR>", { desc = "Reset Git hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Git hunk" })

vim.keymap.set("n", "<leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })

vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })

vim.keymap.set("n", "<leader>f<CR>", function() Snacks.picker.resume() end, { desc = "Resume" })

vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fD", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })

vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set({ "n", "v" }, "<leader>f.", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })

vim.keymap.set("n", "<leader>fu", function() Snacks.picker.undo() end, { desc = "Find Undo" })

vim.keymap.set("n", '<leader>f"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Marks" })

vim.keymap.set("n", "<leader>fC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.command_history() end, { desc = "Command History" })

vim.keymap.set("n", "<leader>fj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>fl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })

vim.keymap.set("n", "<leader>fH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>fM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>fa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Find Notifications" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

vim.keymap.set("n", "<leader>E", function() Snacks.picker.explorer() end, { desc = "Snacks Explorer" })

vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gri", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gry", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "grN", function() Snacks.rename.rename_file() end, { desc = "Rename File" })

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
