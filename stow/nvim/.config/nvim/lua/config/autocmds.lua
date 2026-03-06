-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("strip_trailing_whitespace", { clear = true }),
  callback = function()
    -- Skip for JavaScript files temporarily for debugging
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "javascriptreact" then
      return
    end

    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Open neo-tree automatically when entering a directory (e.g. after project picker)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("open_neo_tree", { clear = true }),
  callback = function()
    -- Only open if the argument is a directory or no args (restored session)
    if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.defer_fn(function()
        require("neo-tree.command").execute({ action = "show", dir = LazyVim.root() })
      end, 50)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "haml",
  callback = function()
    vim.b.ts_autotag_enable = false
  end,
})
