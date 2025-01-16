return {
  {
    "catppuccin/nvim",
    dir = P.catppuccin,
    name = "catppuccin",
    priority = 1000,
    opts = {
      kitty = false,
      integrations = {
        treesitter_context = true,
        mini = { enabled = true, indentscope_color = "blue" },
        noice = true,
        blink_cmp = true,
        snacks = true,
        fzf = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = false,
          },
        },
        dropbar = { enabled = true },
        headlines = true,
        lsp_trouble = true,
        aerial = true,
        which_key = true,
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#010101",
          crust = "#020202",
        },
      },
      highlight_overrides = {
        all = function(colors)
          return {
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            Visual = { bg = colors.surface0, style = nil },
            Folded = { bg = colors.mantle },
            TreesitterContextBottom = { style = nil },
            SnacksPickerBorder = { bg = colors.mantle, fg = colors.blue },
            SnacksPickerTitle = { link = "IncSearch" },
          }
        end,
      },
    },
  },
  {
    "folke/snacks.nvim",
    dir = P.snacks,
    priority = 1000,
    lazy = false,

    opts = {
      input = { enabled = true },
      scope = { enabled = true },
      quickfile = { enabled = true },

      notifier = { enabled = true, style = "minimal", top_down = false },

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
          ui = {
            selected = "",
            live = "󰐰",
          },
          diagnostics = {
            Error = "",
            Warn = "",
            Hint = "",
            Info = "",
          },
        },
      },

      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "recent_files", cwd = true, limit = 8, padding = 1 },
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
          _G.dd = function(...) require("snacks").debug.inspect(...) end
          _G.bt = function() require("snacks").debug.backtrace() end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          require("snacks").toggle.diagnostics():map("<leader>ud")
          require("snacks").toggle.line_number():map("<leader>ul")
          require("snacks").toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          require("snacks").toggle.treesitter():map("<leader>uT")
          require("snacks").toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,

    keys = {
      { "<leader>gc", function() require("snacks").picker.git_log() end, desc = "Git Log" },
      { "<leader>gS", function() require("snacks").picker.git_status() end, desc = "Git Status" },
      { "<leader>gf", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },

      { "<leader>fm", function() require("snacks").picker.marks() end, desc = "Marks" },
      { "<leader>/", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
      { "<leader>f<CR>", function() require("snacks").picker.resume() end, desc = "Resume" },
      { "<leader>fC", function() require("snacks").picker.commands() end, desc = "Commands" },
      { "<leader>fc", function() require("snacks").picker.command_history() end, desc = "Command History" },
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>fd", function() require("snacks").picker.diagnostics_buffer() end, desc = "Diagnostics" },
      { "<leader>fD", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>f.", function() require("snacks").picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
      { "<leader>fh", function() require("snacks").picker.help() end, desc = "Help Pages" },
      { "<leader>fk", function() require("snacks").picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fM", function() require("snacks").picker.man() end, desc = "Man Pages" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent" },
      { '<leader>f"', function() require("snacks").picker.registers() end, desc = "Registers" },
      { "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" }, --
      { "<leader>fw", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>fs", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },

      { "<leader>fa", function() require("snacks").picker.autocmds() end, desc = "Autocmds" },
      { "<leader>fH", function() require("snacks").picker.highlights() end, desc = "Highlights" },
      { "<leader>fj", function() require("snacks").picker.jumps() end, desc = "Jumps" },
      { "<leader>fl", function() require("snacks").picker.loclist() end, desc = "Location List" },
      { "<leader>fq", function() require("snacks").picker.qflist() end, desc = "Quickfix List" },
      { "<leader>fp", function() require("snacks").picker.projects() end, desc = "Projects" },

      { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Definition" },
      { "grr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
      { "gri", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gry", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    },
  },

  {
    "monaqa/dial.nvim",
    dir = P.dial,
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      { "g<C-a>", function() return require("dial.map").inc_gnormal() end, expr = true, desc = "Increment" },
      { "g<C-x>", function() return require("dial.map").dec_gnormal() end, expr = true, desc = "Decrement" },
      { "<C-a>", mode = "v", function() return require("dial.map").inc_visual() end, expr = true, desc = "Increment" },
      { "<C-x>", mode = "v", function() return require("dial.map").dec_visual() end, expr = true, desc = "Decrement" },
      { "g<C-a>", mode = "v", function() return require("dial.map").inc_gvisual() end, expr = true, desc = "Increment" },
      { "g<C-x>", mode = "v", function() return require("dial.map").dec_gvisual() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.case.new({ types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" } }),
        },
      })
    end,
  },
}
