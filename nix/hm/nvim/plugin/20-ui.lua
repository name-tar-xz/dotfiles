vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
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
  end
end)
