vim.api.nvim_create_autocmd("BufEnter", {
  once = true,
  group = vim.api.nvim_create_augroup("bars", { clear = true }),
  callback = function()
    require("dropbar").setup({ icons = { ui = { bar = { separator = "  ", extends = "…" }, menu = { separator = "", indicator = " " } } } })

    local conditions, get_hl = require("heirline.conditions"), require("heirline.utils").get_highlight

    local colors = {
      red = get_hl("MiniIconsRed").fg,
      green = get_hl("MiniIconsGreen").fg,
      purple = get_hl("MiniIconsPurple").fg,
      yellow = get_hl("MiniIconsYellow").fg,
      orange = get_hl("MiniIconsOrange").fg,
      azure = get_hl("MiniIconsAzure").fg,
      blue = get_hl("MiniIconsBlue").fg,
      teal = get_hl("MiniIconsCyan").fg,

      bright_bg = get_hl("NormalFloat").bg,
      dark_fg = get_hl("LineNr").fg,
      light_blue = get_hl("Operator").fg,
    }

    local Align = { provider = "%=" }
    local Space = setmetatable({ provider = " " }, {
      __call = function(_, n) return { provider = string.rep(" ", n) } end,
    })

    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_colors = {
          n = "blue",
          i = "green",
          v = "purple",
          V = "purple",
          ["\22"] = "purple",
          c = "orange",
          s = "purple",
          S = "purple",
          ["\19"] = "purple",
          R = "yellow",
          r = "yellow",
          ["!"] = "red",
          t = "red",
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      -- provider = function(self) return " %2(" .. self.mode_names[self.mode] .. "%)" end,
      provider = " ",
      -- Same goes for the highlight. Now the background will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], bold = true }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
      },
    }

    local GitBranch = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      provider = function(self) return " " .. self.status_dict.head .. "  " end,
      hl = { bold = true, fg = "purple" },
    }

    local FileIcon = {
      init = function(self)
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self) return self.icon and (self.icon .. " ") end,
      hl = function(self) return { fg = self.icon_color } end,
    }

    local FileType = {
      provider = function() return vim.bo.filetype end,
      hl = { italic = true },
    }

    local FileSize = {
      provider = function()
        -- stackoverflow, compute human readable file size
        local suffix = { "b", "k", "M", "G", "T", "P", "E" }
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize
        if fsize < 1024 then
          return fsize .. suffix[1]
        end
        local i = math.floor((math.log(fsize) / math.log(1024)))
        return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
      end,
      hl = { fg = "orange" },
    }

    local FileFlags = {
      {
        condition = function() return vim.bo.modified end,
        provider = " ",
        hl = { fg = "orange" },
      },
      {
        condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
        provider = " ",
        hl = { fg = "yellow" },
      },
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,

      static = {
        error_icon = " ",
        warn_icon = " ",
        info_icon = " ",
        hint_icon = " ",
      },

      init = function(self)
        local count = vim.diagnostic.count(0)
        self.errors = count[vim.diagnostic.severity.ERROR]
        self.warnings = count[vim.diagnostic.severity.WARN]
        self.hints = count[vim.diagnostic.severity.HINT]
        self.info = count[vim.diagnostic.severity.INFO]
      end,

      update = { "DiagnosticChanged", "BufEnter" },

      { provider = function(self) return self.errors and (" " .. self.error_icon .. self.errors) end, hl = { fg = "red" } },
      { provider = function(self) return self.warnings and (" " .. self.warn_icon .. self.warnings) end, hl = { fg = "yellow" } },
      { provider = function(self) return self.info and (" " .. self.info_icon .. self.info) end, hl = { fg = "azure" } },
      { provider = function(self) return self.hints and (" " .. self.hint_icon .. self.hints) end, hl = { fg = "teal" } },
    }

    local GitChange = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = "orange" },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ("  " .. count)
        end,
        hl = { fg = "green" },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ("  " .. count)
        end,
        hl = { fg = "red" },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ("  " .. count)
        end,
        hl = { fg = "yellow" },
      },
    }

    local SearchCount = {
      condition = function() return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0 end,
      init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
          self.search = search
        end
      end,
      provider = function(self)
        local search = self.search
        return string.format(" %d/%d", search.current, math.min(search.total, search.maxcount))
      end,
    }

    local MacroRec = {
      condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
      provider = function() return " @" .. vim.fn.reg_recording() end,
      update = {
        "RecordingEnter",
        "RecordingLeave",
      },
    }

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },

      -- Or complicate things a bit and get the servers names
      {
        provider = function()
          local names = {}
          for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return " " .. table.concat(names, " ")
        end,
        hl = { fg = "green" },
      },
    }

    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = "%l:%2c %P",
      -- hl = { fg = "teal", bg = "bright_bg" },
    }

    local ScrollBar = {
      static = {
        -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = "light_blue" },
    }

    require("heirline").setup({
      statusline = {
        ViMode,
        Space(2),
        GitBranch,
        FileIcon,
        FileType,
        Space(1),
        FileFlags,
        FileSize,
        { condition = conditions.has_diagnostics, Space(1) },
        Diagnostics,
        { condition = conditions.is_git_repo, Space(1) },
        GitChange,
        Align,

        SearchCount,
        Space(1),
        MacroRec,

        Align,
        Space(2),
        LSPActive,
        { condition = conditions.lsp_attached, Space(2) },
        Ruler,
        Space(1),
        ScrollBar,
        Space(2),
        ViMode,
        hl = { bg = colors.bright_bg },
      },
      -- winbar = WinBar,
      -- tabline = TabLine,

      opts = {
        colors = colors,
      },
    })
  end,
})
