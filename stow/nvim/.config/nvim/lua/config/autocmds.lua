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

-- Open neo-tree automatically after persistence restores a session
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  group = vim.api.nvim_create_augroup("open_neo_tree", { clear = true }),
  callback = function()
    require("neo-tree.command").execute({ action = "show", dir = LazyVim.root() })
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "haml",
  callback = function()
    vim.b.ts_autotag_enable = false
  end,
})
