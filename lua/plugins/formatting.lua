return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format file",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable for large files
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > 1024 * 500 then -- 500 KB
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
      },
    },
  },
}
