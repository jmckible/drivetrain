return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Find the sections table
    opts.sections = opts.sections or {}

    -- Modify section_z to use 12-hour format
    opts.sections.lualine_z = {
      function()
        return os.date("%l:%M %p") -- 12-hour format with AM/PM
      end,
    }
  end,
}
