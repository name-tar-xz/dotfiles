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
