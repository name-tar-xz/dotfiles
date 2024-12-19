return {
  {
    "folke/which-key.nvim",
    dir = P.which_key,
    event = "VeryLazy",
    opts = {
      icons = { group = "", separator = "" },
      disable = { filetypes = { "TelescopePrompt" } },

      spec = {
        mode = { "n", "v" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>g", group = "Git", icon = "󰊢" },
        { "<leader>l", group = "LSP", icon = "" },
        { "<leader>p", group = "ackages", icon = "󰏖" },
        { "<leader>x", desc = "Trouble", icon = "󱖫" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },

        { "<leader>w", icon = "" },
        { "<leader>/", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>y", hidden = true },
      },
    },
  },
  {
    "folke/noice.nvim",
    dir = P.noice,
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = { enabled = true },
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
    dependencies = { "MunifTanjim/nui.nvim", dir = P.nui },
  },
  {
    "stevearc/oil.nvim",
    dir = P.oil,
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
  {
    "nvim-telescope/telescope.nvim",
    -- dir = P.telescope,
    cmd = "Telescope",
    dependencies = {
      { "debugloop/telescope-undo.nvim", dir = P.telescope_undo },
      "nvim-treesitter/nvim-treesitter",
      { "nvim-telescope/telescope-fzf-native.nvim", dir = P.telescope_fzf_native },
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
            vim_diff_opts = { ctxlen = 4 },
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
    "lewis6991/gitsigns.nvim",
    dir = P.gitsigns,
    event = "User GitFile",
    cond = not vim.opt.diff:get(),
    opts = {
      numhl = true,
      signcolumn = false,
      signs_staged_enable = false,
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dir = P.ufo,
    event = "BufEnter",
    dependencies = { "kevinhwang91/promise-async", dir = P.promise_async },
    opts = {
      preview = {
        win_config = { winblend = 0 },
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function() return { "treesitter", "indent" } end,
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
    dir = P.todo_comments,
    event = "User File",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim", dir = P.plenary },
    opts = { signs = false },
  },
  {
    "NvChad/nvim-colorizer.lua",
    dir = P.colorizer,
    event = "BufReadPre",
    opts = { user_default_options = { css = true, tailwind = true } },
  },
}
