-- Basic sane defaults; LazyVim sets many, keep minimal here
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 200
opt.completeopt = "menu,menuone,noselect"
-- Keep UI stable: reserve space for signs (git/diagnostics)
opt.signcolumn = "yes:2" -- reserve 2 columns to avoid any left-shift when multiple signs appear
opt.numberwidth = 4 -- keep line number column stable (prevents jump at 100+ lines)
-- Global statusline for modern look
opt.laststatus = 3

-- Indentation
opt.autoindent = true
-- Prefer filetype indent scripts over smartindent for JS/TS
opt.smartindent = false
opt.cindent = false

-- which-key responsiveness
vim.o.timeout = true
vim.o.timeoutlen = 400
