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
      mode = { "n", "x" },
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

  local gs = require("gitsigns")
  gs.setup({
    numhl = false,
    signcolumn = true,
    signs_staged_enable = true,
    on_attach = vim.schedule_wrap(function(bufnr)
      local function set(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { buffer = bufnr })) end

      set("n", "]c", gs.next_hunk, { desc = "Next Git hunk" })
      set("n", "[c", gs.prev_hunk, { desc = "Previous Git hunk" })
      set("n", "<leader>gl", gs.blame_line, { desc = "View Git blame" })
      set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Git hunk" })
      set("n", "<leader>gr", gs.reset_buffer, { desc = "Reset Git buffer" })
      set("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Git buffer" })
      set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Unstage Git hunk" })
      set("n", "<leader>gd", gs.diffthis, { desc = "View Git diff" })

      set("n", "<leader>gh", gs.reset_hunk, { desc = "Reset Git hunk" })
      set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Git hunk" })
      set("x", "<leader>gh", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Git hunk" })
      set("x", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Git hunk" })

      set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
      set("n", "<leader>gi", function() Snacks.picker.git_status() end, { desc = "Git Status" })
      set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
    end),
  })
end)
