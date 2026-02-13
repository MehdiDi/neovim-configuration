-- Mason setup: manages LSP/DAP/formatters installers
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- LSP servers / tools to preinstall
      "typescript-language-server",
      "eslint-lsp",
      "prettierd",
      "clangd",
      "clang-format",
      "kotlin-language-server",
      "ktlint",
      "prisma-language-server",
      "omnisharp",
      "sourcekit-lsp",
      "gopls",
      "goimports",
      "gofumpt",
      -- You can add more here (e.g. "lua-language-server", "stylua")
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local registry = require("mason-registry")
    local ensure = opts.ensure_installed or {}
    for _, tool in ipairs(ensure) do
      local ok, pkg = pcall(registry.get_package, tool)
      if ok then
        if not pkg:is_installed() then pkg:install() end
      else
        vim.notify(("Mason package %s not found"):format(tool), vim.log.levels.WARN)
      end
    end
  end,
}
