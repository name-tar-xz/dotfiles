vim.loader.enable()
require("options")
require("keybinds")

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" }, missing = false },
  lockfile = nil,
  rocks = { enabled = false },
  performance = {
    reset_packpath = false,
    rtp = {
      reset = false,
      disabled_plugins = {
        "tohtml",
        "gzip",
        "zipPlugin",
        "netrwPlugin",
        "tarPlugin",
        "tutor",
      },
    },
  },
  change_detection = { notify = false },
})
