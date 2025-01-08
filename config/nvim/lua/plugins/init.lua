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
      notifier = { enabled = true, style = "minimal", top_down = false },
      quickfile = { enabled = true },

      statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },

      dashboard = {
        enabled = true,
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
