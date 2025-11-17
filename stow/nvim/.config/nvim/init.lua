-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Ensure files end with a newline
vim.opt.fixendofline = true
vim.opt.endofline = true
