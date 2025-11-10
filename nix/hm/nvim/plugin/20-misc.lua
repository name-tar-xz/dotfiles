vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  once = true,
  group = vim.api.nvim_create_augroup("misc", { clear = true }),
  callback = function()
    vim.cmd.packadd("nvim.undotree")

    vim.g.matchup_matchparen_offscreen = { method = "popup", syntax_hl = 1, border = "none" }
    vim.g.matchup_transmute_enabled = 1

    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.case.new({ types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" } }),
      },
    })

    require("flash").setup({
      jump = { autojump = true },
      modes = { char = { jump_labels = true }, search = { enabled = true } },
      prompt = { enabled = false },
    })

    require("treesj").setup({ use_default_keymaps = false, max_join_length = math.huge })

    require("treesitter-context").setup({ max_lines = 3 })
  end,
})
