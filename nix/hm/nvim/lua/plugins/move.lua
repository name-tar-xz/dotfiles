return {
  {
    "folke/flash.nvim",
    dir = P.flash,
    event = "VeryLazy",
    opts = {
      jump = { autojump = true },
      modes = { char = { jump_labels = true } },
      prompt = { enabled = false },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    dir = P.spider,
    keys = {
      { "w", function() require("spider").motion("w") end, mode = { "n", "x", "o" } },
      { "e", function() require("spider").motion("e") end, mode = { "n", "x", "o" } },
      { "b", function() require("spider").motion("b") end, mode = { "n", "x", "o" } },
      { "ge", function() require("spider").motion("ge") end, mode = { "n", "x", "o" } },
    },
    opts = {},
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    dir = P.texobjs,
    event = "VeryLazy",
    opts = { keymaps = { useDefaults = true, disabledDefaults = { "il", "al" } } },
  },
}
