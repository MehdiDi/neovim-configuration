local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  b.formatting.prettier,
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "jsx", "tsx", "svelte", "prisma", "go" } },

  b.formatting.stylua,

  b.formatting.clang_format,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
