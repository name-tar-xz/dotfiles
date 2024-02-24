return {
  "nvim-neorg/neorg",
  enabled = true,
  cmd = "Neorg",
  event = "VeryLazy",
  build = ":Neorg sync-parsers",
  init = function() vim.g.maplocalleader = " " end,
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {
        config = {
          -- icon_preset = "diamond",
          icons = { todo = { undone = { icon = "_" } } },
        },
      }, -- Adds pretty icons to your documents
      ["core.keybinds"] = {}, -- Adds default keybindings
      ["core.export"] = {},
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      }, -- Enables support for completion plugins
      ["core.journal"] = {}, -- Enables support for the journal module
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/Documents/notes",
            schedule = "~/Documents/schedule",
          },
        },
      },
      -- ["core.integrations.telescope"] = {},
    },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
}
