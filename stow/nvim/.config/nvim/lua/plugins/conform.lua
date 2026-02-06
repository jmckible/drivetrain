-- Disable conform.nvim auto-format on save for JavaScript/TypeScript
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Explicitly disable formatters for JS/TS
      javascript = {},
      javascriptreact = {},
      typescript = {},
      typescriptreact = {},
    },
  },
}
