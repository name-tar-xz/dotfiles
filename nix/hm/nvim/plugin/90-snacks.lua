---@diagnostic disable: undefined-global
require("snacks").setup({
  input = { enabled = true },
  scope = { enabled = true },
  quickfile = { enabled = true },
  image = { enabled = true },

  notifier = {
    enabled = true,
    style = "minimal",
    top_down = false,
    icons = {
      error = " ",
      warn = " ",
      info = " ",
    },
  },

  statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },

  picker = {
    ui_select = true,

    layouts = { sidebar = { layout = { position = "right" } } },

    previewers = { git = { native = true } },
    icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      },
    },

    win = {
      input = {
        keys = {
          ["<a-s>"] = { "flash", mode = { "n", "i" } },
          ["s"] = { "flash" },
        },
      },
    },
    actions = {
      flash = function(picker)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
            },
          },
          action = function(match)
            local idx = picker.list:row2idx(match.pos[1])
            picker.list:_move(idx, true, true)
          end,
        })
      end,
    },
  },

  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "recent_files", cwd = true, limit = 10, padding = 1 },
    },
    preset = {
      header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███  ████████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████]],
    },
  },
})

vim.schedule(function()
  -- Setup some globals for debugging (lazy-loaded)
  _G.dd = function(...) Snacks.debug.inspect(...) end
  _G.bt = function() Snacks.debug.backtrace() end
  vim._print = function(_, ...) dd(...) end -- Override print to use snacks for `:=` command

  -- Create some toggle mappings
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  Snacks.toggle.treesitter():map("<leader>uT")
  Snacks.toggle.inlay_hints():map("<leader>uh")

  vim.keymap.set("n", "<leader>c", function() Snacks.bufdelete.delete() end, { desc = "Close buffer" })

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
  vim.keymap.set({ "n", "x" }, "<leader>f.", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
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
  vim.keymap.set("n", "grt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  vim.keymap.set("n", "grN", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
end)
