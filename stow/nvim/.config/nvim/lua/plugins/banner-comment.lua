local function create_banner_comment()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- Trim whitespace and get the text
  local text = line:match("^%s*(.-)%s*$")

  -- Get current indentation
  local indent = line:match("^(%s*)")

  -- Capitalize and space out the text
  local spaced_text = text:upper():gsub("(.)", "%1 "):sub(1, -2)

  -- The closing # should be at column 80 (position 80)
  -- So total line length should be 80 chars
  local target_column = 80

  -- Top/bottom line: indent + "# " + dashes + " #" = 80 chars total
  local content_width = target_column - #indent - 4 -- 4 for "# " and " #"
  local top_line = indent .. "# " .. string.rep("-", content_width) .. " #"

  -- Middle line: indent + "# " + padding + text + padding + " #" = 80 chars total
  local text_width = #spaced_text
  local left_padding = math.floor((content_width - text_width) / 2)
  local right_padding = content_width - left_padding - text_width
  local mid_line = indent
    .. "# "
    .. string.rep(" ", left_padding)
    .. spaced_text
    .. string.rep(" ", right_padding)
    .. " #"

  local bot_line = top_line

  -- Replace current line with banner
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { top_line, mid_line, bot_line })
end

-- Create a user command to call the function
vim.api.nvim_create_user_command("BannerComment", create_banner_comment, {})

-- Create keymap for <Leader>cb
vim.keymap.set("n", "<Leader>cb", create_banner_comment, { desc = "Create banner comment" })

-- Return empty table for plugin manager
return {}
