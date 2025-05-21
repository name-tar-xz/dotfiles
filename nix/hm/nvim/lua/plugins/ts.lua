return {
  {
    "nvim-treesitter/nvim-treesitter",
    dir = P.treesitter,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", dir = P.treesitter_textobjects },
      { "nvim-treesitter/nvim-treesitter-context", dir = P.treesitter_context, opts = { max_lines = 3 } },
      {
        "andymass/vim-matchup",
        dir = P.matchup,
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "popup", syntax_hl = 1 }
          vim.g.matchup_transmute_enabled = 1
        end,
      },
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "VeryLazy" },
    main = "nvim-treesitter.configs",
    opts = {
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },
      indent = { enable = true },
      matchup = { enable = true },

      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]p"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]P"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[p"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[P"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
      },
    },
  },
  {
    "Wansmer/treesj",
    dir = P.treesj,
    keys = { { "gS", function() require("treesj").toggle() end, desc = "Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false, max_join_length = 9999 },
  },
}
