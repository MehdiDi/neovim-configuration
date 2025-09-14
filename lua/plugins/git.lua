return {
  -- Magit-like UI for Git
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    keys = {
      { "<leader>gg", function() require("neogit").open({ kind = "split" }) end, desc = "Neogit status" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit commit" },
      { "<leader>gp", function() require("neogit").open({ "push" }) end, desc = "Neogit push" },
    },
    opts = {
      integrations = { diffview = true },
      disable_signs = true,
      console_timeout = 2000,
    },
  },

  -- Rich diff UI and file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", ":DiffviewOpen<CR>", desc = "Diffview: Open" },
      { "<leader>gD", ":DiffviewClose<CR>", desc = "Diffview: Close" },
      { "<leader>gh", ":DiffviewFileHistory %<CR>", desc = "Diffview: File history" },
      { "<leader>gH", ":DiffviewFileHistory<CR>", desc = "Diffview: Repo history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },

  -- Blame popup with patch for the current line
  {
    "rhysd/git-messenger.vim",
    keys = {
      { "<leader>gb", "<cmd>GitMessenger<CR>", desc = "Blame (popup with patch)" },
    },
    init = function()
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_floating_win_opts = { border = "rounded" }
      vim.g.git_messenger_include_diff = "current" -- show the hunk that touched the line
    end,
  },

  -- Telescope git pickers via commands
  {
    -- Git pickers via Telescope; plugin is configured elsewhere
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gB", ":Telescope git_branches<CR>", desc = "Git branches (Telescope)" },
      { "<leader>gl", ":Telescope git_commits<CR>",  desc = "Git log (Telescope)" },
      { "<leader>gL", ":Telescope git_bcommits<CR>", desc = "File log (Telescope)" },
    },
  },
}
