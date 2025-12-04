vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  once = true,
  group = vim.api.nvim_create_augroup("misc", { clear = true }),
  callback = function()
    vim.cmd.packadd("nvim.undotree")
    vim.keymap.set("n", "<leader>o", function() require("undotree").open() end)

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
    vim.keymap.set("n", "<C-a>", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" })
    vim.keymap.set("n", "<C-x>", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" })
    vim.keymap.set("n", "g<C-a>", function() return require("dial.map").inc_gnormal() end, { expr = true, desc = "Increment" })
    vim.keymap.set("n", "g<C-x>", function() return require("dial.map").dec_gnormal() end, { expr = true, desc = "Decrement" })
    vim.keymap.set("x", "<C-a>", function() return require("dial.map").inc_visual() end, { expr = true, desc = "Increment" })
    vim.keymap.set("x", "<C-x>", function() return require("dial.map").dec_visual() end, { expr = true, desc = "Decrement" })
    vim.keymap.set("x", "g<C-a>", function() return require("dial.map").inc_gvisual() end, { expr = true, desc = "Increment" })
    vim.keymap.set("x", "g<C-x>", function() return require("dial.map").dec_gvisual() end, { expr = true, desc = "Decrement" })

    require("flash").setup({
      jump = { autojump = true },
      modes = { char = { jump_labels = true }, search = { enabled = true } },
      prompt = { enabled = false },
    })
    vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
    vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
    vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
    vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
    vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

    require("treesj").setup({ use_default_keymaps = false, max_join_length = math.huge })
    vim.keymap.set("n", "gS", function() require("treesj").toggle() end)
  end,
})
