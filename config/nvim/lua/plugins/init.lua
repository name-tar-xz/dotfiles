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
        telescope = { style = "nvchad" },
        dropbar = { enabled = true },
        headlines = true,
        neotree = true,
        notify = true,
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
            Visual = { bg = colors.surface0, style = {} },
            Folded = { bg = colors.mantle },
          }
        end,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts = { ignore = "^$" },
  },
  { "famiu/bufdelete.nvim", dir = P.bufdelete, event = "BufAdd" },
  { "mrjones2014/smart-splits.nvim", dir = P.smart_splits, event = "BufAdd" },

  {
    "monaqa/dial.nvim",
    dir = P.dial,
    keys = {
      {
        "<C-a>",
        mode = { "v" },
        function() return require("dial.map").inc_visual() end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        mode = { "v" },
        function() return require("dial.map").dec_visual() end,
        expr = true,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        mode = { "v" },
        function() return require("dial.map").inc_gvisual() end,
        expr = true,
        desc = "Increment",
      },
      {
        "g<C-x>",
        mode = { "v" },
        function() return require("dial.map").dec_gvisual() end,
        expr = true,
        desc = "Decrement",
      },
      {
        "<C-a>",
        function() return require("dial.map").inc_normal() end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function() return require("dial.map").dec_normal() end,
        expr = true,
        desc = "Decrement",
      },
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
          augend.case.new({
            types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" },
          }),
        },
      })
    end,
  },
  {
    "chentoast/marks.nvim",
    dir = P.marks,
    event = "User File",
    opts = {
      excluded_filetypes = {
        "qf",
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
        "alpha",
        "netrw",
        "neo-tree",
      },
    },
  },
}
