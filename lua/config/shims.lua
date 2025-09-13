-- Neovim compatibility shims
local M = {}

-- Unify vim.lsp.inlay_hint API across 0.9 (function) and 0.10+ (table.enable)
do
  local ih = vim.lsp and vim.lsp.inlay_hint
  if type(ih) == "function" then
    -- Wrap into a table with enable() but keep callable behavior for old usage
    local fn = ih
    local wrapper = {
      enable = function(buf, val)
        pcall(fn, buf, val)
      end,
      is_enabled = function()
        return true
      end,
    }
    setmetatable(wrapper, {
      __call = function(_, ...)
        return fn(...)
      end,
    })
    vim.lsp.inlay_hint = wrapper
  end
end

return M
