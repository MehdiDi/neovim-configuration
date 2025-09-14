-- Optional UI tweaks: colorscheme and minimal dressing
return {
  -- Embark theme
  {
    "embark-theme/vim",
    name = "embark",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("embark")
    end,
  },

  -- Improved UI for vim.ui.select/input (cursor-anchored floating windows)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "builtin" },
        builtin = {
          border = "rounded",
          relative = "cursor", -- anchor the menu at the cursor position
          anchor = "NW",
          max_width = 0.5,
          min_width = 20,
          max_height = 12,
        },
      },
      input = {
        border = "rounded",
      },
    },
  },

  -- Tweak highlight for diff/gitsigns so deleted lines are readable
  {
    "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function()
      local function set_diff_hl()
        -- Make deleted text readable on red backgrounds
        local red_fg = "#ffdddd"
        pcall(vim.api.nvim_set_hl, 0, "DiffDelete", { fg = red_fg })
        pcall(vim.api.nvim_set_hl, 0, "GitSignsDelete", { fg = red_fg })
        pcall(vim.api.nvim_set_hl, 0, "GitSignsDeleteLn", { fg = red_fg })
        pcall(vim.api.nvim_set_hl, 0, "GitSignsDeleteInline", { fg = red_fg })
        pcall(vim.api.nvim_set_hl, 0, "GitSignsDeletePreview", { fg = red_fg })
        pcall(vim.api.nvim_set_hl, 0, "GitSignsDeleteVirtLn", { fg = red_fg })
      end
      set_diff_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diff_hl })
    end,
  },
}
