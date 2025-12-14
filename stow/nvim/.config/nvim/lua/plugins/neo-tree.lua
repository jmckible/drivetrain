return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      mappings = {
        -- Y = copy full path (default)
        -- y = copy filename only
        ["y"] = function(state)
          local node = state.tree:get_node()
          local filename = vim.fn.fnamemodify(node.path, ":t")
          vim.fn.setreg("+", filename)
          vim.notify("Copied filename: " .. filename)
        end,
      },
    },
  },
}
