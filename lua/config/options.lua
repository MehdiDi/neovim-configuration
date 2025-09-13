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

-- Indentation
opt.autoindent = true
-- Prefer filetype indent scripts over smartindent for JS/TS
opt.smartindent = false
opt.cindent = false

-- which-key responsiveness
vim.o.timeout = true
vim.o.timeoutlen = 400
