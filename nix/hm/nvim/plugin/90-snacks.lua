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
      error = vim.diagnostic.config().signs.text[1],
      warn = vim.diagnostic.config().signs.text[2],
      info = vim.diagnostic.config().signs.text[3],
    },
  },

  statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },

  picker = {
    ui_select = true,

    layouts = { sidebar = { layout = { position = "right" } } },

    previewers = { git = { native = true } },
    icons = {
      diagnostics = {
        Error = vim.diagnostic.config().signs.text[1],
        Warn = vim.diagnostic.config().signs.text[2],
        Hint = vim.diagnostic.config().signs.text[3],
        Info = vim.diagnostic.config().signs.text[4],
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
end)
