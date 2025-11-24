return {
  -- GitHub Copilot core with inline suggestions (VS Code style)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        -- Keymaps for inline suggestions
        keymap = {
          accept = "<C-j>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true, gitcommit = true, ["*"] = true },
    },
  },
}
