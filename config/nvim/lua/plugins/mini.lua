return {
  -- {
  --   "echasnovski/mini.basics",
  --   event = "VeryLazy",
  --   version = false,
  --   opts = {
  --     options = {
  --       basic = true,
  --       extra_ui = false,
  --     },
  --     mappings = {
  --       basic = true,
  --       move_with_alt = true,
  --       windows = true,
  --     },
  --     autocommands = { basic = true },
  --     silent = true,
  --   },
  -- },
  {
    "echasnovski/mini.move",
    keys = {
      { "<A-h>", mode = "n", desc = "Move line left" },
      { "<A-j>", mode = "n", desc = "Move line down" },
      { "<A-k>", mode = "n", desc = "Move line up" },
      { "<A-l>", mode = "n", desc = "Move line right" },
      { "<A-h>", mode = "v", desc = "Move selection left" },
      { "<A-j>", mode = "v", desc = "Move selection down" },
      { "<A-k>", mode = "v", desc = "Move selection up" },
      { "<A-l>", mode = "v", desc = "Move selection right" },
    },
    opts = {
      mappings = {
        left = "<A-h>",
        right = "<A-l>",
        down = "<A-j>",
        up = "<A-k>",
        line_left = "<A-h>",
        line_right = "<A-l>",
        line_down = "<A-j>",
        line_up = "<A-k>",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = { { "gz", desc = "Surround" } },
    opts = {
      mappings = {
        add = "gz" .. "a", -- Add surrounding in Normal and Visual modes
        delete = "gz" .. "d", -- Delete surrounding
        find = "gz" .. "f", -- Find surrounding (to the right)
        find_left = "gz" .. "F", -- Find surrounding (to the left)
        highlight = "gz" .. "h", -- Highlight surrounding
        replace = "gz" .. "r", -- Replace surrounding
        update_n_lines = "gz" .. "n", -- Update `n_lines`
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "User File",
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    event = "User File",
    opts = {},
  },
}
