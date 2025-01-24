return {
  {
    "saghen/blink.cmp",
    dir = P.blink,
    dependencies = { "rafamadriz/friendly-snippets", dir = P.friendly_snippets },
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
      keymap = { preset = "default" },

      appearance = { nerd_font_variant = "mono" },

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

          auto_show = function(ctx) return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) end,
          draw = { treesitter = { "lsp" } },
        },

        documentation = { auto_show = true, auto_show_delay_ms = 0 },

        ghost_text = { enabled = true },
      },

      signature = { enabled = false },
    },
  },
}
