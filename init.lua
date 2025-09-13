-- Set leader before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Compatibility shims (e.g., inlay hints API across 0.9/0.10)
require("config.shims")

-- Load lazy.nvim + plugins
require("config.lazy")
