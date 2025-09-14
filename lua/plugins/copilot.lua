return {
  -- GitHub Copilot core (disabled inline UI; integrated via cmp)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true, gitcommit = true, ["*"] = true },
    },
  },

  -- Bridge Copilot -> nvim-cmp source
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}

