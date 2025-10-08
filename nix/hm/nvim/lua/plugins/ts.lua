return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        opts = {
          textobjects = {
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]s"] = { query = "@class.outer", desc = "Next function start" },
                ["]m"] = { query = "@function.outer", desc = "Next function start" },
                ["]p"] = { query = "@parameter.inner", desc = "Next argument start" },
              },
              goto_next_end = {
                ["]S"] = { query = "@class.outer", desc = "Next function end" },
                ["]M"] = { query = "@function.outer", desc = "Next function end" },
                ["]P"] = { query = "@parameter.inner", desc = "Next argument end" },
              },
              goto_previous_start = {
                ["[s"] = { query = "@class.outer", desc = "Previous function start" },
                ["[m"] = { query = "@function.outer", desc = "Previous function start" },
                ["[p"] = { query = "@parameter.inner", desc = "Previous argument start" },
              },
              goto_previous_end = {
                ["[S"] = { query = "@class.outer", desc = "Previous function end" },
                ["[M"] = { query = "@function.outer", desc = "Previous function end" },
                ["[P"] = { query = "@parameter.inner", desc = "Previous argument end" },
              },
            },
          },
        },
      },
      { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
      {
        "andymass/vim-matchup",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "popup", syntax_hl = 1 }
          vim.g.matchup_transmute_enabled = 1
        end,
      },
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "VeryLazy" },
  },
  {
    "Wansmer/treesj",
    keys = { { "gS", function() require("treesj").toggle() end, desc = "Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false, max_join_length = 9999 },
  },
}
