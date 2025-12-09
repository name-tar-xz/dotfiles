require("catppuccin").setup({
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
        FloatBorder = { bg = colors.mantle, fg = colors.blue },
        SnacksInputNormal = { link = "NormalFloat" },
        SnacksInputBorder = { link = "FloatBorder" },
        SnacksInputTitle = { link = "SnacksPickerListTitle" },
      }
    end,
  },
})

vim.cmd.colorscheme("catppuccin")
