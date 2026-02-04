return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo", "TSUninstall" },
    opts = {
      ensure_installed = {
        -- core
        "lua",
        "vim",
        "vimdoc",
        "query",
        "bash",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "toml",
        -- requested languages
        "typescript",
        "javascript",
        "tsx", -- react/tsx
        "html",
        "css",
        "kotlin",
        "go",
        "c",
        "cpp",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      -- Treesitter indent can be aggressive for JS/TS. Use Vim's indent instead.
      indent = { enable = true, disable = { "javascript", "typescript", "tsx" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 3,
      trim_scope = "outer",
      mode = "cursor",
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },
}
