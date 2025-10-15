return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = require("catppuccin").setup({
      kitty = false,
      float = { solid = true },
      default_integrations = false,

      integrations = {
        blink_cmp = { enabled = true, style = "bordered" },
        dropbar = true,
        flash = true,
        gitsigns = true,
        lsp_trouble = true,
        mini = true,
        snacks = true,
        treesitter_context = true,
        which_key = true,
      },

      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          ok = { "undercurl" },
        },
        inlay_hints = { background = false },
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
            Visual = { style = {} },
            Folded = { bg = colors.mantle },
            TreesitterContextBottom = { style = {} },
            PmenuBorder = { bg = colors.mantle, fg = colors.blue },
            SnacksPickerInputBorder = { link = "PmenuBorder" },
          }
        end,
      },
    }),
    init = function() vim.cmd.colorscheme("catppuccin") end,
  },
  {
    "monaqa/dial.nvim",
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
