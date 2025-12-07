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
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      -- Skip auto-format for JS/TS files
      if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
        return nil
      end
      -- Auto-format other files
      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
}
