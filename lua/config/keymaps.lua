-- Minimal example keymaps; LazyVim provides many already
local map = vim.keymap.set

-- Save/Quit shortcuts
map({ "n", "i" }, "<C-s>", function()
  vim.cmd("w")
end, { desc = "Save" })

map("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })

