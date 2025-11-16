vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  group = vim.api.nvim_create_augroup("icons", { clear = true }),
  callback = function()
    require("mini.icons").setup({ extension = { css = { glyph = "" } } })
    ---@diagnostic disable-next-line: undefined-global
    MiniIcons.mock_nvim_web_devicons()
  end,
})

vim.schedule(function()
  require("which-key").setup({
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
  })

  if not vim.o.diff then
    require("gitsigns").setup({
      numhl = false,
      signcolumn = true,
      signs_staged_enable = true,
    })

    vim.keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next Git hunk" })
    vim.keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous Git hunk" })
    vim.keymap.set("n", "<leader>gl", function() require("gitsigns").blame_line() end, { desc = "View Git blame" })
    vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview Git hunk" })
    vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_buffer() end, { desc = "Reset Git buffer" })
    vim.keymap.set("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Unstage Git hunk" })
    vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "View Git diff" })

    vim.keymap.set("n", "<leader>gh", function() require("gitsigns").reset_hunk() end, { desc = "Reset Git hunk" })
    vim.keymap.set("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Git hunk" })
    vim.keymap.set("v", "<leader>gh", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Git hunk" })
    vim.keymap.set("v", "<leader>gs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Git hunk" })
  end
end)
