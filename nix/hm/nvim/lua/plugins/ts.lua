return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dir = P.treesitter,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", dir = P.treesitter_textobjects },
      { "nvim-treesitter/nvim-treesitter-context", dir = P.treesitter_context, opts = { max_lines = 3 } },
      { "JoosepAlviste/nvim-ts-context-commentstring", dir = P.ts_context_commentstring },

      { "HiPhish/rainbow-delimiters.nvim", dir = P.rainbow_delimiters },
      { "windwp/nvim-ts-autotag", dir = P.ts_autotag },
      { "andymass/vim-matchup", dir = P.matchup },
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "VeryLazy" },
    config = function()
      require("nvim-treesitter.configs").setup({
        autotag = { enable = true },
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
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ak = { query = "@block.outer", desc = "around block" },
              ik = { query = "@block.inner", desc = "inside block" },
              ac = { query = "@class.outer", desc = "around class" },
              ic = { query = "@class.inner", desc = "inside class" },
              al = { query = "@loop.outer", desc = "around loop" },
              il = { query = "@loop.inner", desc = "inside loop" },
              aa = { query = "@parameter.outer", desc = "around argument" },
              ia = { query = "@parameter.inner", desc = "inside argument" },
              af = { query = "@function.outer", desc = "around function " },
              ["if"] = { query = "@function.inner", desc = "inside function " },
              ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
              ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            },
          },
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
      })
    end,
  },
  {
    "Wansmer/treesj",
    dir = P.treesj,
    keys = { { "gS", function() require("treesj").toggle() end, desc = "Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false, max_join_length = 9999 },
  },
}
