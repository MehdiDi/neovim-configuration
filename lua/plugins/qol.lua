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
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 1,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        -- Hunk navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        -- Stage/reset
        map({"n","v"}, "<leader>gs", gs.stage_hunk, "Stage hunk")
        map({"n","v"}, "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        -- Info/preview
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk (float)")
        map("n", "<leader>gP", function()
          if gs.preview_hunk_inline then gs.preview_hunk_inline() else gs.preview_hunk() end
        end, "Preview hunk (inline)")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff this")
        -- Text object for hunks
        map({"o","x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Inside hunk")
      end,
    },
  },

  -- Surround: add/change/delete brackets, quotes, tags, etc.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Multiple cursors: <C-n> to add/select next occurrence
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Multi-cursor: select/add next" },
    },
    init = function()
      -- Keep defaults; adjust visuals and noise
      vim.g.VM_default_mappings = 1
      vim.g.VM_theme = "iceblue"
      vim.g.VM_show_warnings = 0
    end,
  },
}
