return {
	"folke/snacks.nvim",
	opts = function(_, opts)
		-- Disable scrolling animations
		opts.scroll = opts.scroll or {}
		opts.scroll.enabled = false

		-- Completely disable explorer - we use neo-tree
		opts.explorer = { enabled = false }

		return opts
	end,
	keys = {
		-- Explicitly disable snacks explorer keymaps so neo-tree can use them
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fe", false },
		{ "<leader>fE", false },
	},
}
