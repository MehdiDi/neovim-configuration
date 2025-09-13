-- Mason setup: manages LSP/DAP/formatters installers
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- LSP servers / tools to preinstall
      "typescript-language-server",
      "eslint-lsp",
      "prettierd",
      -- You can add more here (e.g. "lua-language-server", "stylua")
    },
  },
}
