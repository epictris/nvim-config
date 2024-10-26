vim.cmd('highlight ColorColumn guibg=#333340')
vim.cmd('highlight! link LineNr DevIconCmake')

vim.cmd('highlight! link CursorLineNr @number')
vim.cmd('hi clear CursorLine')
vim.cmd('highlight! QuickFixLine guibg=#34343D guifg=none')

vim.cmd('highlight Sneak guibg=#cbccc6 guifg=#2a313d')

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

