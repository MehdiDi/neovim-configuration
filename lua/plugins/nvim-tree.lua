return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader><leader>", "<cmd>NvimTreeToggle<cr>", desc = "Explorer: toggle" },
      { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer: reveal file" },
    },
    opts = {
      view = { width = 32 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}
