-- Disable LSP auto-format on save for JavaScript/TypeScript
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        -- Keep eslint for diagnostics but disable formatting
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
      ts_ls = {
        -- Keep ts_ls for completions but disable formatting
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
    },
  },
}
