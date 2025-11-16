vim.loader.enable()
require("vim._extui").enable({ enable = true })

vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1

vim.g.mapleader = vim.keycode("<Space>") -- Set <Space> as the <Leader> key
vim.g.maplocalleader = vim.keycode("<Space>")

vim.opt.backspace:append("nostop") -- don't stop backspace at insert
vim.opt.diffopt:append({ linematch = 60, algorithm = "histogram", ["indent-heutistic"] = true }) -- enable linematch diff algorithm
vim.opt.fillchars:append({ diff = "╱", eob = " ", fold = " ", foldopen = "", foldclose = "" })
vim.opt.formatoptions:append({ c = false, ["/"] = true, n = true, p = true })
vim.opt.shortmess:append({ s = true, I = true, a = true, W = true, A = true, S = true }) -- disable search count wrap and startup messages
vim.opt.viewoptions:remove("curdir") -- disable saving current directory with views
vim.opt.completeopt = { "menu", "menuone", "popup", "noinsert", "fuzzy" } -- Options for insert mode completion
vim.opt.cursorlineopt = { "screenline", "number" }
vim.opt.listchars = { trail = "·", nbsp = "␣", tab = "  " }
vim.opt.sessionoptions = { "buffers", "curdir", "winsize", "skiprtp", "folds" }
vim.opt.switchbuf = { "useopen", "usetab", "uselast" }
vim.opt.wildmode = { "longest:full", "full" }

vim.o.autoindent = true
vim.o.autowrite = true
vim.o.autowriteall = true
vim.o.clipboard = "unnamed" -- Connection to the system clipboard
vim.o.cmdheight = 0 -- hide command line unless needed
vim.o.concealcursor = "c"
vim.o.conceallevel = 2
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.copyindent = true -- Copy the previous indentation on autoindenting
vim.o.cursorline = true -- Highlight the text line of the cursor
vim.o.expandtab = true -- Enable the use of space in tab
vim.o.fileencoding = "utf-8" -- File content encoding for the buffer
vim.o.foldcolumn = "0"
vim.o.foldlevel = 1e2
vim.o.foldmethod = "indent"
vim.o.foldtext = ""
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.history = 1e3 -- Number of commands to remember in a history table
vim.o.hlsearch = true
vim.o.ignorecase = true -- Case insensitive searching
vim.o.inccommand = "split"
vim.o.jumpoptions = "view"
vim.o.laststatus = 3 -- globalstatus
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = "a" -- Enable mouse support
vim.o.number = true -- Show numberline
vim.o.numberwidth = 1
vim.o.preserveindent = true -- Preserve indent structure as much as possible
vim.o.pumheight = 10 -- Height of the pop up menu
vim.o.relativenumber = true -- Show relative numberline
vim.o.ruler = false
vim.o.scrolloff = 1e3 -- Number of lines to keep above and below the cursor
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)
vim.o.shell = "/usr/bin/env zsh"
vim.o.shiftround = true
vim.o.shiftwidth = 0 -- Number of space inserted for indentation
vim.o.showmode = false -- Disable showing modes in command line
vim.o.showtabline = 0 -- always display tabline
vim.o.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.o.signcolumn = "yes"
vim.o.smartcase = true -- Case sensitivie searching
vim.o.smartindent = true
vim.o.spelloptions = "camel"
vim.o.splitbelow = true -- Splitting a new window below the current one
vim.o.splitkeep = "screen" -- Reduce scroll during window split
vim.o.splitright = true -- Splitting a new window at the right of the current one
vim.o.swapfile = false
vim.o.tabstop = 2 -- Number of space in a tab
vim.o.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.o.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.o.title = true
vim.o.titlestring = " %t"
vim.o.undofile = true -- Enable persistent undo
vim.o.undolevels = 1e5
vim.o.updatetime = 200 -- Length of time to wait before triggering the plugin
vim.o.virtualedit = "block"
vim.o.winborder = "solid"
vim.o.wrap = false -- Disable wrapping of lines longer than the width of window
vim.o.writebackup = false -- Disable making a backup before overwriting a file

vim.lsp.enable({
  "arduino_language_server",
  "basedpyright",
  "biome",
  "cssls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "nixd",
  "ruff",
  "tailwindcss",
  "taplo",
  "typos_lsp",
  "vtsls",
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    source = false,
    hl_mode = "combine",
    virt_text_pos = "eol",
  },
  float = {
    header = "",
    scope = "cursor",
    severity_sort = true,
    source = false,
    focusable = false,
  },
  jump = { on_jump = function() vim.diagnostic.open_float({ scope = "cursor" }) end },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})
