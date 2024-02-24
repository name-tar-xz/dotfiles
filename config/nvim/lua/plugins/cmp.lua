return {
  -- {
  -- 	"Exafunction/codeium.vim",
  -- 	event = "User File",
  -- 	config = function()
  -- 		vim.keymap.set("i", "<C-g>", function()
  -- 			return vim.fn["codeium#Accept"]()
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<C-;>", function()
  -- 			return vim.fn["codeium#CycleCompletions"](1)
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<C-,>", function()
  -- 			return vim.fn["codeium#CycleCompletions"](-1)
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<C-x>", function()
  -- 			return vim.fn["codeium#Clear"]()
  -- 		end, { expr = true })
  -- 		vim.keymap.set("n", "<leader>;", function()
  -- 			if vim.g.codeium_enabled == true then
  -- 				vim.cmd("CodeiumDisable")
  -- 			else
  -- 				vim.cmd("CodeiumEnable")
  -- 			end
  -- 		end, { noremap = true, desc = "Toggle Codeium active" })
  -- 	end,
  -- },
  {
    "L3MON4D3/LuaSnip",
    build = vim.fn.has("win32") == 0 and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp" or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
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
        { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
        { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
      },
    },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end, { "vscode", "snipmate", "lua" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",

      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",

      "hrsh7th/cmp-buffer",
      "FelipeLema/cmp-async-path",

      "amarakon/nvim-cmp-fonts",

      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = { color_square_width = 0 } },
      "jcha0713/cmp-tw2css",

      "ray-x/cmp-treesitter",

      -- { "tzachar/cmp-tabnine", build = "./install.sh" },
      -- {
      --   "Exafunction/codeium.nvim",
      --   cmd = "Codeium",
      --   build = ":Codeium Auth",
      --   opts = {},
      -- },

      "onsails/lspkind.nvim",
    },
    event = { "InsertEnter", "CmdlineEnter" },

    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      local luasnip = require("luasnip")
      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer-lines" },
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

          { name = "luasnip" },
          { name = "nvim_lsp" },

          { name = "codeium" },
          { name = "cmp_tabnine" },

          { name = "async_path" },
          { name = "buffer" },

          { name = "nerdfont" },
          { name = "emoji" },

          { name = "treesitter" },

          { name = "fonts", option = { space_filter = "-" } },

          { name = "cmp-tw2css" },

          -- { name = "neorg" },
        }),
        completion = {
          completeopt = "menu,menuone,preview,noselect,noinsert",
        },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,

          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
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
              before = require("tailwindcss-colorizer-cmp").formatter,
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
    -- config = function(_, opts)
    --   for _, source in ipairs(opts.sources) do
    --     source.group_index = source.group_index or 1
    --   end
    --   require("cmp").setup(opts)
    -- end,
  },
}
