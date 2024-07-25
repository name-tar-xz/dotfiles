return {
  {
    "L3MON4D3/LuaSnip",
    dir = P.luasnip,
    dependencies = { "rafamadriz/friendly-snippets", dir = P.friendly_snippets },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
      keys = {
        {
          "<tab>",
          function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<tab>",
          function() require("luasnip").jump(1) end,
          mode = "s",
        },
        {
          "<s-tab>",
          function() require("luasnip").jump(-1) end,
          mode = { "i", "s" },
        },
      },
    },
    config = function(_, opts)
      if opts then
        require("luasnip").config.setup(opts)
      end
      vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end, { "vscode", "snipmate", "lua" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dir = P.cmp,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", dir = P.cmp_lsp },
      { "saadparwaiz1/cmp_luasnip", dir = P.cmp_luasnip },
      { "hrsh7th/cmp-nvim-lua", dir = P.cmp_lua },

      { "hrsh7th/cmp-cmdline", dir = P.cmp_cmdline },
      { "dmitmel/cmp-cmdline-history", dir = P.cmp_cmdline_history },

      { "hrsh7th/cmp-buffer", dir = P.cmp_buffer },
      { "FelipeLema/cmp-async-path", dir = P.cmp_async_path },

      -- { "roobert/tailwindcss-colorizer-cmp.nvim", opts = { color_square_width = 0 } },

      { "ray-x/cmp-treesitter", dir = P.cmp_treesitter },

      -- { "tzachar/cmp-tabnine", build = "./install.sh" },
      -- {
      --   "Exafunction/codeium.nvim",
      --   cmd = "Codeium",
      --   build = ":Codeium Auth",
      --   opts = {},
      -- },

      { "onsails/lspkind.nvim", dir = P.lspkind },
    },
    event = { "InsertEnter", "CmdlineEnter" },

    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
          { name = "async_path" },
          { name = "cmdline_history" },
        }),
      })
      return {
        sources = cmp.config.sources({

          { name = "nvim_lsp" },
          { name = "luasnip" },

          { name = "async_path" },
          { name = "buffer" },

          { name = "treesitter" },

          -- { name = "neorg" },
        }),
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,

          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),

        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
              preset = "default",
              -- before = require("tailwindcss-colorizer-cmp").formatter,
              symbol_map = require("symbols"),
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            return kind
          end,
        },

        sorting = defaults.sorting,
      }
    end,
  },
}
