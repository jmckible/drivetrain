-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

vim.keymap.set("n", "<leader>gD", function()
  local files = vim.fn.systemlist("git diff --name-only HEAD")
  if #files == 0 then
    vim.notify("No dirty files", vim.log.levels.INFO)
    return
  end
  local first_file = nil
  for _, file in ipairs(files) do
    if file ~= "" then
      if not first_file then
        first_file = file
      end
      vim.cmd.badd(file)
    end
  end
  if first_file then
    vim.cmd.edit(first_file)
  end
end, { desc = "Open all dirty files" })
