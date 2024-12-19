vim.g.mapleader = " " -- Set <space> as the <leader> key
vim.g.maplocalleader = " "

vim.keymap.set("n", "]a", "<cmd>tabnext<CR>")
vim.keymap.set("n", "]A", "<cmd>tablast<CR>")
vim.keymap.set("n", "[a", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "[A", "<cmd>tabfirst<CR>")

vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set({ "n", "v" }, ":", ";")

vim.opt.backspace:append({ "nostop" }) -- don't stop backspace at insert
vim.opt.diffopt:append("linematch:60") -- enable linematch diff algorithm
vim.opt.fillchars:append({ diff = "╱", eob = " " })
vim.opt.shortmess:append({ s = true, I = true, a = true, W = true }) -- disable search count wrap and startup messages
vim.opt.viewoptions:remove("curdir") -- disable saving current directory with views

vim.opt.clipboard = "unnamed" -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" } -- Options for insert mode completion
vim.opt.concealcursor = "c"
vim.opt.conceallevel = 2
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.fileencoding = "utf-8" -- File content encoding for the buffer
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.inccommand = "split"
vim.opt.laststatus = 3 -- globalstatus
vim.opt.list = true
vim.opt.listchars = { trail = "·", nbsp = "␣" }
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.number = true -- Show numberline
vim.opt.numberwidth = 1
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.scrolloff = 999 -- Number of lines to keep above and below the cursor
vim.opt.shell = "/usr/bin/env zsh"
vim.opt.shiftwidth = 0 -- Number of space inserted for indentation
vim.opt.showmode = false -- Disable showing modes in command line
vim.opt.showtabline = 0 -- always display tabline
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.swapfile = false
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.title = true
vim.opt.titlestring = " %t"
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 250 -- Length of time to wait before triggering the plugin
vim.opt.virtualedit = "block"
vim.opt.wrap = false -- Disable wrapping of lines longer than the width of window
vim.opt.writebackup = false -- Disable making a backup before overwriting a file

vim.lsp.inlay_hint.enable(true)

vim.g.skip_ts_context_commentstring_module = true

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    -- text = { "", "󰌺", "", "" },
    text = { "", "", "", "" },
  },
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

autocmd({ "UIEnter" }, {
  callback = function(event)
    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
    if client ~= nil and client.name == "Firenvim" then
      vim.opt.laststatus = 0
      vim.opt.showcmd = false
      vim.opt.showtabline = 0
      vim.notify = ""

      autocmd({ "TextChanged", "TextChangedI" }, {
        nested = true,
        command = "write",
      })
    end
  end,
})

local function event(event, delay)
  local emit_event = function() vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false }) end
  if delay == false then
    emit_event()
  else
    vim.schedule(emit_event)
  end
end
local function cmd(cmd, show_error)
  if type(cmd) == "string" then
    cmd = { cmd }
  end
  if vim.fn.has("win32") == 1 then
    cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
  end
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln(("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result))
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  desc = "User File and User GitFile",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    local current_file = vim.fn.resolve(vim.fn.expand("%"))
    if not (current_file == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      event("File")
      if cmd({ "git", "-C", vim.fn.fnamemodify(current_file, ":p:h"), "rev-parse" }, false) then
        event("GitFile")
        vim.api.nvim_del_augroup_by_name("file_user_events")
      end
    end
  end,
})
