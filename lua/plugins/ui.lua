-- Optional UI tweaks: colorscheme and minimal dressing
return {
  -- Embark theme
  {
    "embark-theme/vim",
    name = "embark",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("embark")
    end,
  },
}
