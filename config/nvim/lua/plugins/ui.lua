return {
  {
    "folke/which-key.nvim",
    dir = P.which_key,
    event = "VeryLazy",
    opts = {
      icons = { group = "" },
      disable = { filetypes = { "TelescopePrompt" } },

      spec = {
        mode = { "n", "v" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>g", group = "Git", icon = "󰊢" },
        { "<leader>l", group = "LSP", icon = "" },
        { "<leader>p", group = "Packages", icon = "󰏖" },
        { "<leader>x", desc = "Trouble", icon = "󱖫" },
        { "<leader>u", desc = "UI", icon = "" },
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
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = { "MunifTanjim/nui.nvim", dir = P.nui },
  },
  {
    "echasnovski/mini.files",
    dir = P.mini_files,
    event = { "VimEnter */*,.*", "BufNew */*,.*" },
    keys = {
      {
        "<leader>e",
        function()
          if not require("mini.files").close() then
            require("mini.files").open()
          end
        end,
        desc = "Open mini.files",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_preview = 50,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event) require("snacks").rename.on_rename_file(event.data.from, event.data.to) end,
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dir = P.fzf,
    cmd = "FzfLua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = { ["--no-scrollbar"] = true },

        winopts = {
          border = "empty",
          treesitter = { enabled = true },
          backdrop = 0,
        },
        hls = {
          border = "FzfLuaNormal",
          preview_border = "FzfLuaNormal",
          title = "IncSearch",
          preview_title = "IncSearch",
        },

        previewers = {
          builtin = {
            syntax_limit_l = 0,
            syntax_limit_b = 0,
            limit_b = 0,
            context = { max_lines = 2, trim_scope = "inner" },
            treesitter = { enabled = true },
          },
        },

        defaults = { file_icons = "mini" },
        files = {
          actions = {
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = { code_actions = { previewer = "codeaction_native" } },
      }
    end,
    init = function(opts)
      vim.ui.select = function(...)
        require("fzf-lua").register_ui_select(opts.ui_select or nil)
        return vim.ui.select(...)
      end
    end,

    keys = {
      { "<leader>gC", function() require("fzf-lua").git_bcommits() end, desc = "Git commits (current file)" },
      { "<leader>gb", function() require("fzf-lua").git_branches() end, desc = "Git branches" },
      { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git commits (repository)" },
      { "<leader>gS", function() require("fzf-lua").git_status() end, desc = "Git status" },
      { "<leader>gf", function() require("fzf-lua").git_files() end, desc = "Git files" },

      { "<leader>f`", function() require("fzf-lua").marks() end, desc = "Find marks" },
      { "<leader>f/", function() require("fzf-lua").grep_curbuf() end, desc = "Find words in current buffer" },
      { "<leader>f<CR>", function() require("fzf-lua").resume() end, desc = "Resume previous search" },
      { "<leader>fC", function() require("fzf-lua").commands() end, desc = "Find commands" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
      { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "Find buffers" },
      { "<leader>fc", function() require("fzf-lua").grep_cword() end, desc = "Find word under cursor" },
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>fh", function() require("fzf-lua").helptags() end, desc = "Find help" },
      { "<leader>fk", function() require("fzf-lua").keymaps() end, desc = "Find keymaps" },
      { "<leader>fm", function() require("fzf-lua").manpages() end, desc = "Find man" },
      { "<leader>fo", function() require("fzf-lua").oldfiles() end, desc = "Find history" },
      { "<leader>fr", function() require("fzf-lua").registers() end, desc = "Find registers" },
      { "<leader>ft", function() require("fzf-lua").colorschemes({ enable_preview = true }) end, desc = "Find themes" },
      { "<leader>fw", function() require("fzf-lua").live_grep() end, desc = "Find words" },
      { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Find symbols" },

      { "gD", function() require("fzf-lua").lsp_declarations({ jump_to_single_result = true }) end, desc = "Goto Declaration" },
      { "gd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, desc = "Goto Definition" },
      { "gr", function() require("fzf-lua").lsp_references() end, desc = "Goto References" },
      { "gI", function() require("fzf-lua").lsp_implementations() end, desc = "Goto Implementation" },
      { "gY", function() require("fzf-lua").lsp_typedefs({ jump_to_single_result = true }) end, desc = "Goto Type Definition" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    dir = P.gitsigns,
    event = "VeryLazy",
    cond = not vim.o.diff,
    opts = {
      numhl = false,
      signcolumn = true,
      signs_staged_enable = true,
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    dir = P.colorizer,
    event = "BufReadPre",
    opts = { user_default_options = { names = false, css = true, tailwind = true } },
  },
}
