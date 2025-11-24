-- Optional UI tweaks: colorscheme and minimal dressing
return {
  -- Embark theme
  {
    "embark-theme/vim",
    name = "embark",
    lazy = false,
    priority = 1000,
    config = function()
      local function set_embark_background(alpha)
        -- Keep a record for GUI frontends (e.g., Neovide) that honor alpha channels
        if vim.g.neovide then
          local hex = "#1e1c31"
          -- Compose RGBA string Neovide expects (#RRGGBBAA)
          vim.g.neovide_transparency = alpha
          vim.g.neovide_background_color = string.format("%s%02x", hex, math.floor(alpha * 255))
        end

        -- Make the theme respect the terminal/GUI transparency level
        local transparent_groups = {
          "Normal",
          "NormalNC",
          "SignColumn",
          "NormalFloat",
          "FloatBorder",
          "TelescopeNormal",
          "TelescopeBorder",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
        }
        for _, group in ipairs(transparent_groups) do
          pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE", ctermbg = "NONE" })
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "embark",
        callback = function()
          set_embark_background(0.85)
        end,
      })
      set_embark_background(0.85)
      vim.cmd.colorscheme("embark")
    end,
  },

  -- Buffer line (tabs for buffers)
  {
    "akinsho/bufferline.nvim",
    event = { "BufAdd", "BufEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Make the active buffer visually distinct
      highlights = {
        buffer_selected = { bold = true, italic = false, fg = "#FFFFFF" },
        diagnostic_selected = { bold = true, italic = false },
        hint_selected = { bold = true, italic = false },
        info_selected = { bold = true, italic = false },
        warning_selected = { bold = true, italic = false },
        error_selected = { bold = true, italic = false },
        indicator_selected = { fg = "#91ddff", bg = "#1e1c31" },
      },
      options = {
        mode = "buffers",
        numbers = "none",
        diagnostics = false,
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          { filetype = "NvimTree", text = "Explorer", highlight = "Directory", separator = true },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
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
