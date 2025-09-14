return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fw", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
      { "<leader>fr", function() require("telescope.builtin").resume() end,     desc = "Resume last" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles() end,   desc = "Recent files" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          -- Show best matches at the top with a clearer layout
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
            width = 0.95,
            height = 12, -- cap total height ~10 results
            preview_cutoff = 120,
            horizontal = { preview_width = 0.55 },
            vertical = { mirror = false },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          wrap_results = true,
          dynamic_preview_title = true,
          results_title = false,
          set_env = { COLORTERM = "truecolor" },
          -- Include hidden files in grep but ignore .git
          vimgrep_arguments = (function()
            local args = require("telescope.config").values.vimgrep_arguments
            local copy = {}
            for _, v in ipairs(args) do table.insert(copy, v) end
            table.insert(copy, "--hidden")
            table.insert(copy, "--glob")
            table.insert(copy, "!.git/*")
            return copy
          end)(),
          file_ignore_patterns = { ".git/", "node_modules/", "dist/", "build/" },
        },
        pickers = {
          find_files = { hidden = true, theme = "dropdown", previewer = false, results_height = 10 },
          buffers = {
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            theme = "dropdown",
            previewer = false,
            results_height = 10,
          },
          live_grep = {
            theme = "dropdown",
            previewer = false,
            results_height = 10,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
