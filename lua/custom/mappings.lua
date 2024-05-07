---@type MappingsTable
local M = {}

local closed_buffers_stack = {}

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufpath = vim.fn.expand "<afile>:p"
    if bufpath and #bufpath > 0 then
      table.insert(closed_buffers_stack, bufpath)
    end
  end,
})

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-s>"] = {
      function()
        vim.lsp.buf.format { async = false }
        vim.cmd "w"
      end,
      "Save file",
    },
    -- ["<C-e>"] = {
    --   function()
    --     vim.api.nvim_exec('execute "normal! ' .. scroll_amount .. '\\<C-E>"', false)
    --   end,
    --   "Scroll down multiple lines",
    -- },
    -- -- Scroll up
    -- ["<C-y>"] = {
    --   function()
    --     vim.api.nvim_exec('execute "normal! ' .. scroll_amount .. '\\<C-Y>"', false)
    --   end,
    --   "Scroll up multiple lines",
    -- },
    ["<C-b>"] = {
      function()
        if #closed_buffers_stack > 0 then
          local last_buffer = table.remove(closed_buffers_stack)
          vim.cmd("edit " .. last_buffer)
        else
          print "No buffer in history"
        end
      end,
      "Reopen last closed buffer",
    },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

M.dap = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add or remove breakpoint",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run to next breakpoint",
    },
  },
}

M.multiselect = {
  n = {
    ["<leader>ca"] = {
      ":MCstart<CR>",
      " Start multicursor (select word under cursor)",
    },
  },
  v = {
    ["<leader>ca"] = {
      ":MCvisual<CR>",
      " Start multicursor (select visual block)",
    },
  },
}

M.git = {
  n = {
    ["<leader>gs"] = { "<cmd> G<CR>", "Git status" },
    ["<leader>gb"] = { "<cmd> G blame<CR>", "Git blame" },
    ["<leader>ghp"] = { "<cmd> Gitsigns preview_hunk<CR>", "Preview hunk" },
  },
}
M.cmp = {
  i = {
    ["<C-Space>"] = {
      function()
        require("cmp").complete()
      end,
    },
  },
}

return M
