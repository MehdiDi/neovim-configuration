return {
  -- Core LSP client configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local fn = vim.fn

      -- Utility helpers for optional table inputs (env/config overrides)
      local function normalize_list(value)
        if type(value) == "string" and value ~= "" then
          return { value }
        elseif type(value) == "table" then
          local copy = {}
          for _, entry in ipairs(value) do
            if type(entry) == "string" and entry ~= "" then
              table.insert(copy, entry)
            end
          end
          if #copy > 0 then return copy end
        end
      end

      local function detect_arm_toolchain_root()
        local configured = vim.g.arm_toolchain_root
        if configured and configured ~= "" then return configured end
        local candidates = { "arm-none-eabi-clang", "arm-none-eabi-gcc" }
        for _, bin in ipairs(candidates) do
          local resolved = fn.exepath(bin)
          if resolved ~= "" then return fn.fnamemodify(resolved, ":h") end
        end
      end

      local function derive_query_drivers()
        local configured = normalize_list(vim.g.clangd_query_driver)
        if configured then return configured end
        local toolchain_root = detect_arm_toolchain_root()
        if not toolchain_root then return nil end
        return { toolchain_root .. "/arm-none-eabi-*" }
      end

      -- Modern diagnostics: underline + virtual text, no gutter letters
      vim.diagnostic.config({
        signs = false,
        underline = true,
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })
      -- Ensure underline style is visible across colorschemes
      local function set_diag_hl()
        pcall(vim.api.nvim_set_hl, 0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5555" })
        pcall(vim.api.nvim_set_hl, 0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "#ffaf00" })
        pcall(vim.api.nvim_set_hl, 0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "#5fafff" })
        pcall(vim.api.nvim_set_hl, 0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "#5fd7af" })
      end
      set_diag_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diag_hl })

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
        map("n", "gD", function()
          -- Prefer type definition (e.g. class/interface) when available
          local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr })
            or vim.lsp.buf_get_clients(bufnr)
          local has_type = false
          if clients then
            for _, c in pairs(clients) do
              local caps = c.server_capabilities or {}
              if caps.typeDefinitionProvider then
                has_type = true
                break
              end
            end
          end
          if has_type then
            vim.lsp.buf.type_definition()
          elseif vim.lsp.buf.definition then
            vim.lsp.buf.definition()
          else
            vim.lsp.buf.declaration()
          end
        end, "LSP: Type definition (fallback)")
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
      vim.lsp.config("ts_ls", {
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

      -- ESLint (re-enabled) with quiet handlers to avoid intrusive popups
      vim.lsp.config("eslint", {
        -- Keep eslint for code actions and formatting; avoid duplicate diagnostics
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
          ["window/showMessage"] = function() end,
          ["window/logMessage"] = function() end,
          ["textDocument/publishDiagnostics"] = function() end, -- suppress eslint signs
        },
        settings = {
          workingDirectory = { mode = "auto" },
          codeAction = { disableRuleComment = { enable = true, location = "separateLine" } },
          format = false,
        },
      })

      -- Prisma (schema.prisma) language server
      vim.lsp.config("prismals", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- C/C++ via clangd
      local cmd = normalize_list(vim.g.clangd_cmd) or { "clangd" }
      cmd = vim.deepcopy(cmd)

      local query_drivers = derive_query_drivers()
      if query_drivers then
        for _, pattern in ipairs(query_drivers) do
          table.insert(cmd, "--query-driver=" .. pattern)
        end
      end

      local fallback_flags = normalize_list(vim.g.clangd_fallback_flags)
      if not fallback_flags then
        local fallback_target = vim.g.clangd_fallback_target
          or vim.env.CLANGD_FALLBACK_TARGET
        if fallback_target and fallback_target ~= "" then
          fallback_flags = { "-target=" .. fallback_target }
          local fallback_cpu = vim.g.clangd_fallback_mcpu or vim.env.CLANGD_FALLBACK_MCPU
          if fallback_cpu and fallback_cpu ~= "" then
            table.insert(fallback_flags, "-mcpu=" .. fallback_cpu)
          end
        end
      end

      local clangd_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      if query_drivers or vim.g.clangd_cmd then clangd_opts.cmd = cmd end
      if fallback_flags then
        clangd_opts.init_options = { fallbackFlags = fallback_flags }
      end
      vim.lsp.config("clangd", clangd_opts)

      -- Kotlin via kotlin-language-server (formatting handled by ktlint)
      vim.lsp.config("kotlin_language_server", {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      })

      -- Go via gopls; rely on external formatters (goimports/gofumpt)
      vim.lsp.config("gopls", {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
              nilness = true,
              unusedwrite = true,
              unusedvariable = true,
              fillreturns = true,
              shadow = true,
            },
            codelenses = {
              gc_details = false,
              test = true,
              tidy = true,
            },
            staticcheck = true,
          },
        },
      })

      -- C# / Unity via OmniSharp (works with standard .sln and Unity projects)
      local function get_omnisharp_cmd()
        local binary = "omnisharp"
        if vim.fn.has("win32") == 1 then binary = binary .. ".cmd" end

        -- Prefer Mason-managed binary (available in stdpath("data")/mason/bin)
        local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", binary)
        if vim.loop.fs_stat(mason_bin) then
          return { mason_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
        end

        -- Fallback to PATH lookup (covers manual installs / global dotnet tool)
        local system_path = vim.fn.exepath(binary)
        if system_path ~= "" then
          return { system_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
        end
      end

      local function find_omnisharp_root(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == "" then return end
        local start = vim.fs.dirname(fname)
        local found = vim.fs.find(function(name)
          return name:match("%.sln$") or name:match("%.csproj$") or name == ".git"
        end, { path = start, upward = true, limit = 1 })
        if #found > 0 then
          on_dir(vim.fs.dirname(found[1]))
        else
          on_dir(start)
        end
      end

      local omnisharp_cmd = get_omnisharp_cmd()
      if not omnisharp_cmd then
        vim.notify(
          "OmniSharp executable not found. Run :Mason to install omnisharp or ensure it is on PATH.",
          vim.log.levels.ERROR
        )
      else
        -- Build cmd with all required flags (mirrors lspconfig defaults + Mason path)
        local full_omnisharp_cmd = vim.list_extend(
          vim.deepcopy(omnisharp_cmd),
          { "-z", "DotNet:enablePackageRestore=false", "--encoding", "utf-8" }
        )
        vim.lsp.config("omnisharp", {
          on_attach = function(client, bufnr)
            -- Unity / C# projects usually handle formatting via dotnet format or csharpier
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          root_dir = find_omnisharp_root,
          cmd = full_omnisharp_cmd,
          settings = {
            FormattingOptions = {
              OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
            },
          },
        })
      end

      -- Swift via sourcekit-lsp (prefers xcrun on macOS, falls back to PATH)
      local function get_sourcekit_cmd()
        local xcrun = vim.fn.exepath("xcrun")
        if xcrun ~= "" then
          return { xcrun, "sourcekit-lsp" }
        end
        local sk = vim.fn.exepath("sourcekit-lsp")
        if sk ~= "" then return { sk } end
      end

      local sourcekit_cmd = get_sourcekit_cmd()
      if not sourcekit_cmd then
        vim.notify(
          "sourcekit-lsp not found. Install Xcode Command Line Tools or via Mason (:Mason).",
          vim.log.levels.WARN
        )
      else
        vim.lsp.config("sourcekit", {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = sourcekit_cmd,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname == "" then return end
            local start = vim.fs.dirname(fname)
            local found = vim.fs.find(function(name)
              return name == "Package.swift" or name == ".git" or name:match("%.xcodeproj$")
            end, { path = start, upward = true, limit = 1 })
            if #found > 0 then
              on_dir(vim.fs.dirname(found[1]))
            else
              on_dir(start)
            end
          end,
        })
      end

      local servers = {
        "ts_ls",
        "eslint",
        "prismals",
        "clangd",
        "kotlin_language_server",
        "gopls",
      }
      if omnisharp_cmd then table.insert(servers, "omnisharp") end
      if sourcekit_cmd then table.insert(servers, "sourcekit") end
      vim.lsp.enable(servers)
    end,
  },
}
