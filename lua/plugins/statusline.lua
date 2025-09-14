return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local function lsp_name()
        local buf_clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or {}
        local names = {}
        for _, c in pairs(buf_clients) do
          table.insert(names, c.name)
        end
        if #names == 0 then return "" end
        return "  " .. table.concat(names, ",")
      end
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = {}, winbar = {} },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(s) return s:sub(1,1) end } },
          lualine_b = { { "branch", icon = "" }, { "diff" } },
          lualine_c = {
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
            { "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "[No Name]" } },
          },
          lualine_x = { lsp_name, { "filetype", icon_only = false }, { "encoding", fmt = string.upper }, "fileformat" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {}, lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {}, lualine_z = {},
        },
        extensions = { "quickfix", "fugitive", "nvim-tree", "neo-tree", "trouble", "lazy" },
      }
    end,
  },
}

