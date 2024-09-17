require "core"
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

vim.cmd "colorscheme embark"
-- vim.g.neovide_background_color = "#1E1C31"

-- Function to get the current Git branch
local function get_git_branch()
  local handle = io.popen "git rev-parse --abbrev-ref HEAD"
  local git_branch = handle:read "*a" or ""
  handle:close()
  -- Strip newline character from the end of the branch name
  git_branch = string.gsub(git_branch, "\n$", "")
  return git_branch
end

-- Set the status line in Neovim using Lua
-- vim.o.laststatus = 2 -- Always show the status line
-- vim.o.statusline = "%F%m%r%h%w [POS=%04l,%04v] [%p%%] [LEN=%L] [" .. get_git_branch() .. "]"

-- This sets up the status line and includes the Git branch dynamically
-- It will update when Neovim is restarted or when the configuration is re-sourced

require("lspconfig").prismals.setup {}
-- vim.cmd "highlight Normal guibg=#1E1C31"
vim.cmd "highlight Normal guibg=NONE guifg=#bbbbbb"

-- vim.cmd "hi Normal guifg=#bbbbbb guibg=NONE gui=NONE"
vim.cmd "hi Normal guifg=#bbbbbb"

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"
vim.cmd "set relativenumber"
