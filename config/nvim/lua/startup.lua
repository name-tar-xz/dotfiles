vim.loader.enable()
require("options")
require("keybinds")

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  lockfile = nil,
  rocks = { enabled = false },
  performance = {
    rtp = {
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

vim.cmd.colorscheme("catppuccin")
