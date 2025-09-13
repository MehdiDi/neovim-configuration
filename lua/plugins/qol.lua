return {
  -- Show available keybindings on the fly
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      win = { border = "rounded" },
      defaults = {},
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if wk.add then
        wk.add({
          { "<leader>f", group = "file" },
          { "<leader>g", group = "git" },
          { "<leader>l", group = "lsp" },
        })
      else
        -- fallback for older which-key versions
        wk.register({
          ["<leader>f"] = { name = "+file" },
          ["<leader>g"] = { name = "+git" },
          ["<leader>l"] = { name = "+lsp" },
        })
      end
    end,
  },

  -- Auto insert closing pairs and integrate with cmp
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)
      -- Integrate with nvim-cmp if present
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Comment toggling: gcc, gbc, gc{motion}
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
    },
    opts = {},
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" }, change = { text = "~" }, delete = { text = "_" },
        topdelete = { text = "‾" }, changedelete = { text = "~" }, untracked = { text = "+" },
      },
    },
  },
}
