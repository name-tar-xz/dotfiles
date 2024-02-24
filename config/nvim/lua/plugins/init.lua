return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    opts = {
      -- transparent = true,
      style = "night",
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        local title = "#27a1b9"
        local util = require("tokyonight.util")
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = prompt }
        hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
        hl.TelescopeTitle = { bg = title }

        hl.TreesitterContext = { bg = c.bg }
        hl.TreesitterContextBottom = { underline = true, sp = c.dark3 }

        hl.Folded = { bg = c.bg_dark }

        hl.ModesInsert = { bg = c.green }
        hl.ModesVisual = { bg = c.purple }

        hl.NormalMode = { fg = util.darken(c.blue, 0.2) }
        hl.InsertMode = { bg = util.darken(c.green, 0.15) }
        hl.VisualMode = { fg = c.purple }
        hl.CommandMode = { fg = c.orange }
        hl.ReplaceMode = { fg = c.red }

        hl.LspInlayHint = { bg = nil, fg = "#545c7e" }

        hl.WinBar = { bg = nil, fg = c.fg_dark }
        hl.WinBarNC = { bg = nil, fg = c.fg_gutter }
        hl.Normal = { bg = nil }
      end,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      kitty = false,
      integrations = {
        treesitter_context = true,
        mini = { enabled = true, indentscope_color = "blue" },
        noice = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = false,
          },
        },
        telescope = { style = "nvchad" },
        dropbar = { enabled = true },
        headlines = true,
        neotree = true,
        notify = true,
        lsp_trouble = true,
        aerial = true,
        which_key = true,
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#010101",
          crust = "#020202",
        },
      },
      highlight_overrides = {
        all = function(colors)
          return {
            Visual = { bg = colors.surface0, style = {} },
            Folded = { bg = colors.mantle },
          }
        end,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts = {
      ignore = "^$",
    },
  },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "famiu/bufdelete.nvim", event = "BufAdd" },
  { "mrjones2014/smart-splits.nvim", event = "BufAdd" },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>s", desc = "Search / Replace", mode = { "n", "x" } },
      { "<leader>s" .. "s", function() require("spectre").open() end, desc = "Spectre" },
      { "<leader>s" .. "w", mode = "x", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre (current word)" },
      { "<leader>s" .. "f", function() require("spectre").open_file_search() end, desc = "Spectre (current file)" },
    },

    opts = function()
      return {
        mapping = {
          send_to_qf = { map = "q" },
          replace_cmd = { map = "c" },
          show_option_menu = { map = "o" },
          run_current_replace = { map = "C" },
          run_replace = { map = "R" },
          change_view_mode = { map = "v" },
          resume_last_search = { map = "l" },
        },
      }
    end,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    enabled = false,
    keys = {
      {
        "<leader>db",
        function() require("persistent-breakpoints.api").toggle_breakpoint() end,
        { silent = true },
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function() require("persistent-breakpoints.api").clear_all_breakpoints() end,
        { silent = true },
        desc = "Clear Breakpoints",
      },
      {
        "<leader>dC",
        function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
        { silent = true },
        desc = "Conditional Breakpoint",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    enabled = false,
    event = "User File",
    cmd = { "DiffviewOpen" },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        mode = { "v" },
        function() return require("dial.map").inc_visual() end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        mode = { "v" },
        function() return require("dial.map").dec_visual() end,
        expr = true,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        mode = { "v" },
        function() return require("dial.map").inc_gvisual() end,
        expr = true,
        desc = "Increment",
      },
      {
        "g<C-x>",
        mode = { "v" },
        function() return require("dial.map").dec_gvisual() end,
        expr = true,
        desc = "Decrement",
      },
      {
        "<C-a>",
        function() return require("dial.map").inc_normal() end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function() return require("dial.map").dec_normal() end,
        expr = true,
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.case.new({
            types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" },
          }),
        },
      })
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = { "User File", "InsertEnter" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("neoclip").setup(opts)
      require("telescope").load_extension("neoclip")
    end,
    keys = { { "<leader>fy", function() require("telescope").extensions.neoclip.neoclip() end, desc = "Find yanks (neoclip)" } },
  },
  {
    "chentoast/marks.nvim",
    event = "User File",
    opts = {
      excluded_filetypes = {
        "qf",
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
        "alpha",
        "netrw",
        "neo-tree",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    enabled = false,
    event = "User File",
    opts = function()
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({ tex = false }))
      return {
        check_ts = true,
        ts_config = { java = false },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      }
    end,
  },
  {
    "rmagatti/auto-session",
    enabled = false,
    keys = {
      { "<leader>Ss", "<cmd>SessionSave<CR>", mode = "n", desc = "Save Session" },
      { "<leader>Sl", function() require("auto-session.session-lens").search_session() end, mode = "n", desc = "Load Session" },
      { "<leader>Sd", "<cmd>SessionDelete<CR>", mode = "n", desc = "Delete Session" },
    },
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      auto_session_enabled = false,
      session_lens = {
        -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
        buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
        load_on_setup = true,
        theme_conf = false,
        previewer = false,
      },
    },
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    opts = {},
  },
}
