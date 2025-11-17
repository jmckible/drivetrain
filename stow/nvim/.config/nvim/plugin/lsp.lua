return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        -- Enable ESLint for JavaScript
      },
      ruby_lsp = {
        -- Ruby LSP config
      },
      lua_ls = {},
    },
  },
}
