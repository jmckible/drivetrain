-- ~/.config/nvim/lua/plugins/treesitter-context.lua
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true,
    mode = "topline",
    max_lines = 1, -- How many lines of context to show
    trim_scope = "outer",
  },
}
