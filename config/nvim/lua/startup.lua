vim.loader.enable()
require("options")
require("keybinds")

require("lazy").setup("plugins", {
  defaults = { lazy = true, version = nil, tag = nil },
  install = { colorscheme = { "catppuccin" } },
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
  change_detection = {
    notify = false,
  },
  checker = {
    enabled = false,
    notify = false,
  },
})

vim.cmd.colorscheme("catppuccin")
