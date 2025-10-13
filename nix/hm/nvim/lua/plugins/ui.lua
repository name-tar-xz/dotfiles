return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { group = "" },
      disable = { filetypes = { "TelescopePrompt" } },

      spec = {
        mode = { "n", "v" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>g", group = "Git", icon = "󰊢" },
        { "gr", group = "LSP", icon = "" },
        { "<leader>p", group = "Packages", icon = "󰏖" },
        { "<leader>x", desc = "Trouble", icon = "󱖫" },
        { "<leader>u", desc = "UI", icon = "" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },

        { "<leader>w", icon = "" },
        { "<leader>/", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>y", hidden = true },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    cond = not vim.o.diff,
    opts = {
      numhl = false,
      signcolumn = true,
      signs_staged_enable = true,
    },
    keys = {
      { "]g", function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" },
      { "[g", function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" },
      { "<leader>gl", function() require("gitsigns").blame_line() end, desc = "View Git blame" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview Git hunk" },
      { "<leader>gr", function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" },
      { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" },
      { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "View Git diff" },
      { "<leader>gh", ":Gitsigns reset_hunk<CR>", desc = "Reset Git hunk", mode = { "n", "v" } },
      { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Git hunk", mode = { "n", "v" } },
    },
  },
}
