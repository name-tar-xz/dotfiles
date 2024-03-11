return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufEnter",
    dependencies = {
      name = "telescope-fzf-native.nvim",
      dir = P.telescope_fzf_native,
    },
    opts = {
      icons = {
        kinds = {
          use_devicons = true,
          symbols = require("symbols"),
        },
        ui = { bar = { separator = "  ", extends = "…" }, menu = { separator = "", indicator = " " } },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    event = "BufEnter",
    opts = {
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
  },

  {
    "rebelot/heirline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      opts = function()
        require("nvim-web-devicons").set_default_icon("󰈙", "#6d8086", 66)
        return {
          override_by_filename = {
            ["LICENSE"] = {
              icon = "",
            },
          },
        }
      end,
    },
    event = "BufEnter",
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      -- local colors = require("tokyonight.colors").setup()
      local colors = require("catppuccin.palettes").get_palette("mocha")
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
            v = "mauve",
            V = "mauve",
            ["\22"] = "mauve",
            c = "peach",
            s = "mauve",
            S = "mauve",
            ["\19"] = "mauve",
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
          return { bg = self.mode_colors[mode], fg = "mantle", bold = true }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
        },
      }

      -- ViMode = utils.surround({ "![", "]" }, self.mode_colors[mode], ViMode)

      local GitBranch = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
        end,

        provider = function(self) return " " .. self.status_dict.head .. "  " end,
        hl = { bold = true, fg = "mauve", bg = "mantle" },
      }

      local FileIcon = {
        init = function(self)
          local filename = vim.fn.expand("%:t")
          local extension = vim.fn.expand("%:e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self) return self.icon and (self.icon .. " ") end,
        hl = function(self) return { fg = self.icon_color, bg = "mantle" } end,
      }

      local FileName = {
        provider = function(self)
          -- first, trim the pattern relative to the current directory. For other
          -- options, see :h filename-modifers
          local filename = vim.fn.expand("%:t")
          if filename == "" then
            return "[No Name]"
          end
          -- now, if the filename would occupy more than 1/4th of the available
          -- space, we trim the file path to its initials
          -- See Flexible Components section below for dynamic truncation
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
        -- hl = { bg = "mantle", fg = "surface1" },
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
        hl = { fg = "peach", bg = "mantle" },
      }

      local FileFlags = {
        hl = { bg = "mantle" },
        {
          condition = function() return vim.bo.modified end,
          provider = " ",
          hl = { fg = "peach" },
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
          error_icon = vim.diagnostic.config().signs.text[1] .. " ",
          warn_icon = vim.diagnostic.config().signs.text[2] .. " ",
          info_icon = vim.diagnostic.config().signs.text[3] .. " ",
          hint_icon = vim.diagnostic.config().signs.text[4] .. " ",
        },

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (" " .. self.error_icon .. self.errors)
          end,
          hl = { bg = "mantle", fg = "red" },
        },
        {
          provider = function(self) return self.warnings > 0 and (" " .. self.warn_icon .. self.warnings) end,
          hl = { bg = "mantle", fg = "yellow" },
        },
        {
          provider = function(self) return self.info > 0 and (" " .. self.info_icon .. self.info) end,
          hl = { bg = "mantle", fg = "sky" },
        },
        {
          provider = function(self) return self.hints > 0 and (" " .. self.hint_icon .. self.hints) end,
          hl = { bg = "mantle", fg = "teal" },
        },
      }

      local GitChange = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
        end,

        hl = { fg = "orange", bg = "mantle" },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("  " .. count)
          end,
          hl = { fg = colors.green },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("  " .. count)
          end,
          hl = { fg = colors.red },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("  " .. count)
          end,
          hl = { fg = colors.yellow },
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

      local Lazy = {
        condition = require("lazy.status").has_updates,
        update = { "User", pattern = "LazyUpdate" },
        provider = function() return require("lazy.status").updates() end,
        on_click = {
          callback = function() require("lazy").update() end,
          name = "update_plugins",
        },
        hl = { fg = "yellow", bg = "mantle" },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },

        -- Or complicate things a bit and get the servers names
        {
          provider = function()
            local names = {}
            for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
              table.insert(names, server.name)
            end
            return " " .. table.concat(names, " ")
          end,
          hl = { fg = "green", bg = "mantle" },
        },
      }

      local Ruler = {
        -- %l = current line number
        -- %L = number of lines in the buffer
        -- %c = column number
        -- %P = percentage through file of displayed window
        provider = "%l:%2c %P",
        -- hl = { fg = "teal", bg = "mantle" },
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
        hl = { fg = "sapphire", bg = "mantle" },
      }

      local function is_virtual_line() return vim.v.virtnum < 0 end
      local function is_wrapped_line() return vim.v.virtnum > 0 end
      local function not_in_fold_range() return vim.fn.foldlevel(vim.v.lnum) <= 0 end
      local function not_fold_start(line)
        line = line or vim.v.lnum
        return vim.fn.foldlevel(line) <= vim.fn.foldlevel(line - 1)
      end
      local function fold_opened(line) return vim.fn.foldclosed(line or vim.v.lnum) == -1 end

      local Number = {
        condition = function() return vim.opt.number:get() end,
        { provider = "%=" },
        {
          provider = function()
            local sign = vim.fn.sign_getplaced(vim.fn.bufname(), { group = "*", lnum = vim.v.lnum })[1].signs[1]
            if sign ~= nil and sign.group ~= "gitsigns_extmark_signs_" then
              return "%s"
            else
              return "%{v:relnum?v:relnum:v:lnum}"
            end
          end,
        },
        { provider = " " },
      }

      local Fold = {
        condition = function() return vim.opt.foldcolumn:get() ~= "0" end,
        provider = function()
          if is_wrapped_line() or is_virtual_line() then
            return ""
          elseif not_in_fold_range() or not_fold_start() then
            return " "
          elseif fold_opened() then
            return ""
          else
            return ""
          end
        end,
        hl = { fg = "surface1" },
        on_click = {
          name = "heirline_fold_click_handler",
          callback = function()
            local line = vim.fn.getmousepos().line
            if not_fold_start(line) then
              return
            end
            vim.cmd.execute("'" .. line .. "fold" .. (fold_opened(line) and "close" or "open") .. "'")
          end,
        },
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
          Lazy,
          Space(2),
          LSPActive,
          { condition = conditions.lsp_attached, Space(2) },
          Ruler,
          Space(1),
          ScrollBar,
          Space(2),
          ViMode,
        },
        -- winbar = WinBar,
        -- tabline = TabLine,
        statuscolumn = {
          Fold,
          Space(1),
          Number,
        },

        opts = {
          colors = colors,
        },
      })
    end,
  },
}
