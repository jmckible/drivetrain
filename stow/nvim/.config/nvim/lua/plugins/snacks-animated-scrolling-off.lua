return {
	"folke/snacks.nvim",
	opts = function(_, opts)
		-- Disable scrolling animations
		opts.scroll = opts.scroll or {}
		opts.scroll.enabled = false

		-- Completely disable explorer - we use neo-tree
		if opts.explorer then
			opts.explorer = vim.tbl_deep_extend("force", opts.explorer, {
				enabled = false,
			})
		else
			opts.explorer = { enabled = false }
		end

		return opts
	end,
	keys = {
		-- Disable all explorer keymaps
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fe", false },
	},
}
