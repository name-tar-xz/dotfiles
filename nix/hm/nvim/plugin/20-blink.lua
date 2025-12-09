vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  group = vim.api.nvim_create_augroup("cmp", { clear = true }),
  callback = function()
    require("blink.cmp").setup({
      appearance = { nerd_font_variant = "mono" },

      cmdline = { completion = { menu = { auto_show = true } } },

      completion = {
        list = {
          selection = {
            preselect = function(ctx) return ctx.mode ~= "cmdline" end,
            auto_insert = function(ctx) return ctx.mode == "cmdline" end,
          },
        },

        menu = {
          border = vim.o.pumborder,
          winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
          draw = { treesitter = { "lsp" } },
        },

        documentation = { auto_show = true, auto_show_delay_ms = 0 },

        ghost_text = { enabled = true },
      },

      signature = { enabled = true },
    })
  end,
})
