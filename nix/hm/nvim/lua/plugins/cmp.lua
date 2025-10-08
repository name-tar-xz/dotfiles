return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
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
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          draw = { treesitter = { "lsp" } },
        },

        documentation = { auto_show = true, auto_show_delay_ms = 0 },

        ghost_text = { enabled = true },
      },

      signature = { enabled = true },
    },
  },
}
