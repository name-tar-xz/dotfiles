---@diagnostic disable: undefined-global
return {
  "folke/snacks.nvim",
  dir = P.snacks,
  priority = 1000,
  lazy = false,

  opts = {
    input = { enabled = true },
    scope = { enabled = true },
    quickfile = { enabled = true },

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

      layouts = {
        default = {
          layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "solid",
              title = "{source} {live}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", border = "vpad", width = 0.6 },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "vpad",
            title = " {source} {live}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list", border = "none" },
              { win = "preview", width = 0.6, border = "left" },
            },
          },
        },
        vscode = {
          preview = false,
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            border = "none",
            box = "vertical",
            { win = "input", height = 1, border = "solid", title = "{source} {live}", title_pos = "center" },
            { win = "list", border = "hpad" },
            { win = "preview", border = "rounded" },
          },
        },
      },

      previewers = { git = { native = true } },
      icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
      },
    },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "recent_files", cwd = true, limit = 10, padding = 1 },
        { section = "startup" },
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
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,

  keys = {
    { "<leader>c", function() Snacks.bufdelete() end, desc = "Close buffer" },

    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gS", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },

    { "<leader>f<CR>", function() Snacks.picker.resume() end, desc = "Resume" },

    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },

    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

    { "<leader>fw", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>f.", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },

    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Find Undo" },

    { '<leader>f"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },

    { "<leader>fC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History" },

    { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },

    { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Find Notifications" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Definition" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gry", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File" },
  },
}
