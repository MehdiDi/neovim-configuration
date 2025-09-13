return {
  -- Core LSP client configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")

      -- capabilities (extend if cmp is present later)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp = pcall(require, "cmp_nvim_lsp")
      if ok then capabilities = cmp.default_capabilities(capabilities) end

      -- common on_attach with a few useful keymaps
      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "LSP: Goto definition")
        map("n", "gr", vim.lsp.buf.references, "LSP: References")
        map("n", "gi", vim.lsp.buf.implementation, "LSP: Implementations")
        map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
        map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
        map("n", "<leader>fm", function()
          local ok, conform = pcall(require, "conform")
          if ok then
            conform.format({ async = true, lsp_fallback = true })
          else
            vim.lsp.buf.format({ async = true })
          end
        end, "Format")
        if vim.lsp.inlay_hint then
          if type(vim.lsp.inlay_hint) == "table" and vim.lsp.inlay_hint.enable then
            pcall(vim.lsp.inlay_hint.enable, bufnr, true)
          elseif type(vim.lsp.inlay_hint) == "function" then
            pcall(vim.lsp.inlay_hint, bufnr, true)
          end
        end
      end

      -- TypeScript/JavaScript server (new name: ts_ls; fallback: tsserver)
      local ts = lspconfig.ts_ls or lspconfig.tsserver
      if ts then
        ts.setup({
          on_attach = function(client, bufnr)
            -- Prefer Prettier over tsserver formatting
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          settings = {
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayVariableTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayVariableTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
        })
      end

      -- ESLint (re-enabled) with quiet handlers to avoid intrusive popups
      if lspconfig.eslint then
        lspconfig.eslint.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = {
            ["window/showMessage"] = function() end,
            ["window/logMessage"] = function() end,
          },
          settings = {
            workingDirectory = { mode = "auto" },
            codeAction = { disableRuleComment = { enable = true, location = "separateLine" } },
            format = false,
          },
        })
      end
    end,
  },
}
