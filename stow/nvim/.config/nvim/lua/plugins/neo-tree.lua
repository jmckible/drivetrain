return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- Re-enable neo-tree keybindings (snacks explorer disabled them)
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
  },
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
