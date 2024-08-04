-- Function to check if a path is a directory
local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

-- Get the command line arguments
local args = vim.fn.argv()

-- Check if there is at least one argument and if it's a directory
if #args > 0 then
  if is_directory(args[1]) then
    local oil = require("oil")
    oil.open()
    require('oil.util').run_after_load(0, function()
        if oil.get_cursor_entry() then
          oil.open_preview()
        end
    end)
  end
end
