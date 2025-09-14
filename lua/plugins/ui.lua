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
}
