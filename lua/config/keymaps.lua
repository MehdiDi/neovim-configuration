-- Keymaps are organized by mode: Normal, Insert, Visual
local function map(mode, lhs, rhs, desc, opts)
  local o = { desc = desc }
  if opts then for k, v in pairs(opts) do o[k] = v end end
  vim.keymap.set(mode, lhs, rhs, o)
end

map("n", "<C-s>", function() vim.cmd("w") end, "Save")
-- Clear search highlight with Esc in normal mode
map("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then vim.cmd("nohlsearch") end
end, "Clear search highlight", { silent = true })
map("n", "<leader>wq", ":wq<CR>", "Write and quit")

-- Window navigation with Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")

-- Diagnostics: show float on current cursor position
map("n", "<leader>lf", function()
  local opts = { focus = false, scope = "cursor", border = "rounded", source = "if_many" }
  if vim.diagnostic and vim.diagnostic.open_float then
    vim.diagnostic.open_float(nil, opts)
  end
end, "LSP: Show diagnostic")

-- LSP Code Actions on Ctrl-Comma
local function has_lsp()
  local clients = (vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }))
    or (vim.lsp.buf_get_clients and vim.lsp.buf_get_clients(0))
  return clients and next(clients) ~= nil
end
map("n", "<C-,>", function()
  if has_lsp() then vim.lsp.buf.code_action() else vim.notify("No LSP attached", vim.log.levels.WARN) end
end, "LSP: Code actions", { silent = true })
map("v", "<C-,>", function()
  if has_lsp() then vim.lsp.buf.code_action() else vim.notify("No LSP attached", vim.log.levels.WARN) end
end, "LSP: Code actions", { silent = true })

-- LSP hover on symbol under cursor (Shift-K)
map("n", "K", function()
  local has_clients = false
  if vim.lsp.get_clients then
    has_clients = next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
  elseif vim.lsp.buf_get_clients then
    has_clients = next(vim.lsp.buf_get_clients(0)) ~= nil
  end
  if has_clients then
    vim.lsp.buf.hover()
  else
    -- Fallback to default K behavior (keywordprg/man/help)
    vim.cmd("normal! K")
  end
end, "LSP: Hover docs or default K")

-- Close current buffer (also catch <C-w><C-w>)
map("n", "<C-w>w", ":bd<CR>", "Close buffer", { silent = true })
map("n", "<C-w><C-w>", ":bd<CR>", "Close buffer", { silent = true })

-- Buffers: jump to alternate/previous buffer
map("n", "<C-b>b", function()
  local ok = pcall(require("bufferline").cycle, -1)
  if not ok then vim.cmd("b#") end
end, "Previous buffer", { silent = true })
-- Also map Ctrl-6 to alternate buffer (toggle last two)
-- Note: <C-^> is Vim's built-in toggle; many terminals send it as <C-6>
map("n", "<C-6>", ":b#<CR>", "Alternate buffer", { silent = true })
-- Terminals often treat <C-4> as SIGQUIT ("^\\"). Use Alt-4 as a safe option.
map("n", "<A-4>", ":b#<CR>", "Alternate buffer (Alt-4)", { silent = true })
-- User-requested: map Ctrl-\\ to toggle to the last buffer
map("n", "<C-\\>", ":b#<CR>", "Alternate buffer (Ctrl-\\)", { silent = true })

-- Buffers: cycle next/previous with Tab / Shift-Tab
map("n", "<Tab>", function()
  local ok = pcall(vim.cmd, "BufferLineCycleNext")
  if not ok then vim.cmd("bnext") end
end, "Next buffer", { silent = true })
map("n", "<S-Tab>", function()
  local ok = pcall(vim.cmd, "BufferLineCyclePrev")
  if not ok then vim.cmd("bprevious") end
end, "Previous buffer", { silent = true })


-- INSERT MODE
map("i", "<C-s>", "<Esc>:w<CR>", "Save and exit insert", { silent = true })
map("i", "jk", "<Esc>", "Exit to normal (jk)", { silent = true })
map("i", "<C-l>", "<Right>", "Move right", { silent = true })
map("i", "<C-h>", "<Left>", "Move left", { silent = true })

-- VISUAL MODE
-- Keep selection when indenting
map("v", "<", "<gv", "Indent left (keep selection)")
map("v", ">", ">gv", "Indent right (keep selection)")

-- Move lines with Alt/Option + j/k
-- Normal: move current line up/down
map("n", "<A-j>", ":m .+1<CR>==", "Move line down", { silent = true })
map("n", "<A-k>", ":m .-2<CR>==", "Move line up",   { silent = true })
-- Visual: move selected block up/down and reselect
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down", { silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up",   { silent = true })
