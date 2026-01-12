vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  once = true,
  group = vim.api.nvim_create_augroup("mini", { clear = true }),
  callback = function()
    require("mini.move").setup()

    require("mini.surround").setup({
      mappings = {
        add = "gz" .. "a", -- Add surrounding in Normal and Visual modes
        delete = "gz" .. "d", -- Delete surrounding
        find = "gz" .. "f", -- Find surrounding (to the right)
        find_left = "gz" .. "F", -- Find surrounding (to the left)
        highlight = "gz" .. "h", -- Highlight surrounding
        replace = "gz" .. "r", -- Replace surrounding
        update_n_lines = "gz" .. "n", -- Update `n_lines`

        suffix_last = "p",
      },
    })

    local spec = require("mini.ai").gen_spec
    local tss = spec.treesitter
    require("mini.ai").setup({
      mappings = { around_next = "at", inside_next = "it", around_last = "aT", inside_last = "iT" },
      custom_textobjects = {
        f = tss({ a = "@function.outer", i = "@function.inner" }),
        u = spec.function_call(), -- u for "Usage"
        U = spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        ["?"] = tss({ a = "@conditional.outer", i = "@conditional.inner" }),
        l = tss({ a = "@loop.outer", i = "@loop.inner" }),
        c = tss({ a = "@class.outer", i = "@class.inner" }),
        a = tss({ a = "@parameter.outer", i = "@parameter.inner" }),
        k = tss({ a = "@block.outer", i = "@block.inner" }),

        g = function() -- Whole Buffer
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,

        o = tss({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits

        S = { { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" }, "^().*()$" },
      },
    })
  end,
})

vim.schedule(function()
  require("mini.files").setup({
    windows = {
      preview = true,
      width_preview = 50,
    },
    mappings = { synchronize = "<leader>w" },
  })

  vim.keymap.set("n", "<leader>e", function()
    if not require("mini.files").close() then require("mini.files").open() end
  end, { desc = "Open mini.files" })
end)

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  group = vim.api.nvim_create_augroup("rename", { clear = true }),
  callback = function(event) require("snacks").rename.on_rename_file(event.data.from, event.data.to) end,
})
