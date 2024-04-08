return {
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███  ████████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("LDR n  ", "  New File  ", ""),
        dashboard.button("LDR f f", "  Find File  ", ""),
        dashboard.button("LDR f o", "󰈙  Recents  ", ""),
        dashboard.button("LDR f w", "󰈭  Find Word  ", ""),
        dashboard.button("LDR f '", "  Bookmarks  ", ""),
        dashboard.button("LDR S l", "  Last Session  ", ""),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function() require("lazy").show() end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Loaded  " .. stats.loaded .. "/" .. stats.count .. " in 󰥔 " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { group = "", separator = "" },
      disable = { filetypes = { "TelescopePrompt" } },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto", icon = "a" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>f"] = { name = " Find" },
        ["<leader>p"] = { name = "󰏖 Packages" },
        ["<leader>l"] = { name = " LSP" },
        ["<leader>b"] = { name = "󰓩 Buffers" },
        ["<leader>bs"] = { name = "󰒺 Sort Buffers" },
        ["<leader>d"] = { name = " Debugger" },
        ["<leader>g"] = { name = "󰊢 Git" },
        ["<leader>S"] = { name = "󱂬 Session" },
        ["<leader>t"] = { name = " Terminal" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "ago",
          },
          opts = { skip = true },
        },
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 1, 2 },
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = { "VimEnter */*,.*", "BufNew */*,.*" },
    opts = {
      columns = { "permissions", "size", "icon" },
      buf_options = { buflisted = false },
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = { show_hidden = true },
    },
  },
  { "tiagovla/scope.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "debugloop/telescope-undo.nvim",
      {
        name = "telescope-fzf-native.nvim",
        dir = P.telescope_fzf_native,
      },
    },

    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          git_worktrees = vim.g.git_worktrees,
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          mappings = {
            i = {
              ["<C-l>"] = actions.cycle_history_next,
              ["<M-l>"] = actions.cycle_history_next,
              ["<M-h>"] = actions.cycle_history_prev,
              ["<C-h>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<M-j>"] = actions.move_selection_next,
              ["<M-k>"] = actions.move_selection_previous,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },

        extensions = {
          undo = {
            diff_context_lines = 4,
            mappings = {
              i = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["<C-CR>"] = require("telescope-undo.actions").yank_additions,
                ["<S-CR>"] = require("telescope-undo.actions").yank_deletions,
              },
            },
          },
        },
      })
      require("telescope").load_extension("undo")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("aerial")
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "builtin" } },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User GitFile",
    cond = not vim.opt.diff:get(),
    opts = {
      numhl = true,
      signcolumn = false,
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufEnter",
    dependencies = "kevinhwang91/promise-async",
    opts = {
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = { winblend = 0 },
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function()
        if vim.lsp.buf_is_attached(0, 1) then
          return { "lsp", "treesitter" }
        else
          return { "treesitter", "indent" }
        end
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "User File",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { user_default_options = { css = true, tailwind = true } },
  },
}
