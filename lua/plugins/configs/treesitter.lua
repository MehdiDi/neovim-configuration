local options = {
  ensure_installed = { "lua" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  javascript = {
    __default = "// %s",
    jsx_element = "{/* %s */}",
    jsx_fragment = "{/* %s */}",
    jsx_attribute = "// %s",
    comment = "// %s",
  },
  typescript = { __default = "// %s", __multiline = "/* %s */" },
}

return options
