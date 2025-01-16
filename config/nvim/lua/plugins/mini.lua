return {
  {
    "echasnovski/mini.move",
    dir = P.mini_move,
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
    dir = P.mini_surround,
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

        suffix_last = "p",
      },
    },
  },
  {
    "echasnovski/mini.files",
    dir = P.mini_files,
    event = { "VimEnter */*,.*", "BufNew */*,.*" },
    keys = {
      {
        "<leader>e",
        function()
          if not require("mini.files").close() then
            require("mini.files").open()
          end
        end,
        desc = "Open mini.files",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_preview = 50,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event) require("snacks").rename.on_rename_file(event.data.from, event.data.to) end,
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    dir = P.mini_ai,
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    dir = P.mini_bracketed,
    event = "VeryLazy",
    opts = {},
  },
}
