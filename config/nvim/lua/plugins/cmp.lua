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
        menu = { border = "rounded" },
        documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded" } },
      },

      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
}
