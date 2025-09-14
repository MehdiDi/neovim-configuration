-- Keymaps are organized by mode: Normal, Insert, Visual
local function map(mode, lhs, rhs, desc, opts)
  local o = { desc = desc }
  if opts then for k, v in pairs(opts) do o[k] = v end end
  vim.keymap.set(mode, lhs, rhs, o)
end

map("n", "<C-s>", function() vim.cmd("w") end, "Save")
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


-- INSERT MODE
map("i", "<C-s>", "<Esc>:w<CR>", "Save and exit insert", { silent = true })
map("i", "jk", "<Esc>", "Exit to normal (jk)", { silent = true })

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
