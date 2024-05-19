vim.g.mapleader = " "

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

local nmap = function (lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

-- Python formatting (black, ruff)
local format_python = function ()
  local current_file = vim.fn.expand('%:p')
  vim.cmd.w()
  -- vim.cmd('!python -m black '..current_file)
  vim.cmd('!python -m ruff --fix '..current_file)
  vim.cmd('!python -m ruff format '..current_file)
end

-- local normal_command = 'norm yiwOprint("<C-r>"-><C-r>=expand("%")<CR>:<C-r>=line(".")+1<CR>"<Esc>'

local qfx = function()
  local list = vim.fn.getqflist()
  for index, value in ipairs(list) do
    local name = vim.fn.bufname(value.bufnr)
    vim.cmd.norm('yiwOprint("<Esc>pa->'..name..':'..value.lnum..'")<Esc>')
    if index < #list then
      vim.cmd.cnext()
    end
    print(index, name)
  end
end

nmap("<leader>Qp", qfx)


nmap("<C-f>", format_python)

-- Recentre after page up/down and jump to search
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")

-- Easy paste from yank buffer
nmap("<leader>p", '"0p')

-- Easy yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')

-- Easy vertical/horizontal split
nmap("<leader>|", vim.cmd.vsplit)
nmap("<leader>_", vim.cmd.split)


-- VimWiki
nmap("<Leader>ww", "<Plug>VimwikiIndex", { desc = "Open Wiki" })


table.unpack = table.unpack or unpack

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then
    f:close()
  end
  return f ~= nil
end

local function copy_tasks()
  SECONDS_IN_ONE_DAY = 60 * 60 * 24
  local current_file = vim.fn.expand("%:t:r")
  local current_dir = vim.fn.expand("%:p:h") .. "/"
  if current_file == nil then
    return
  end
  local file_date_strings = vim.split(current_file, "-")
  local file_date_nums = {}
  for _, date_string in ipairs(file_date_strings) do
    local date_num = tonumber(date_string)
    if date_num ~= nil then
      table.insert(file_date_nums, date_num)
    end
  end
  assert(#file_date_nums == 3)
  local year, month, day = table.unpack(file_date_nums)
  assert(year >= 1000 and year <= 9999)
  assert(month >= 1 and month <= 12)
  assert(day >= 1 and day <= 31)

  local file_date = (os.time({ year = year, month = month, day = day, hour = 12 }))
  local prev_date_file = os.date("%Y-%m-%d.wiki", file_date - SECONDS_IN_ONE_DAY)
  local next_date_file = os.date("%Y-%m-%d.wiki", file_date + SECONDS_IN_ONE_DAY)

  local current_date_header = os.date("%A %d %B %Y", file_date)

  local prev_date_file_path = current_dir .. prev_date_file

  local lines = {
    "[[" .. prev_date_file .. "#<|]]*<* ,,Prev,,",
    "[[" .. next_date_file .. "#>|]]*>* ,,Next,,",
    "",
    "= " .. current_date_header .. " =",
    "",
  }

  if not file_exists(prev_date_file_path) then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
    return
  end

  local line_type = "HEADER"
  local projects = {}
  local misc_tasks = {}
  local current_project_index = nil

  for line in io.lines(prev_date_file_path) do
    if line_type == "DAILY_TITLE" then
      line_type = "DAILY_INFO"
    end
    if line_type == "PROJECT_TITLE" then
      line_type = "PROJECT_INFO"
    end
    if line_type == "NOTE_TITLE" then
      line_type = "NOTE_BODY"
    end
    if line_type == "CARRYOVER_TASK" then
      line_type = "CARRYOVER_TASK_INFO"
    end
    if line_type == "COMPLETED_TASK" then
      line_type = "COMPLETED_TASK_INFO"
    end

    if
      string.find(line, "%[ %]")
      or string.find(line, "%[.%]")
      or string.find(line, "%[o%]")
      or string.find(line, "%[O%]")
    then
      line_type = "CARRYOVER_TASK"
    end
    if string.find(line, "%[X%]") then
      line_type = "COMPLETED_TASK"
    end
    if string.find(line, "= ") == 1 then
      line_type = "DAILY_TITLE"
    end
    if string.find(line, "== ") == 1 then
      line_type = "PROJECT_TITLE"
    end
    if string.find(line, "=== ") == 1 then
      line_type = "NOTE_TITLE"
    end

    if
      line_type == "HEADER"
      or line_type == "DAILY_TITLE"
      or line_type == "DAILY_INFO"
      or line_type == "COMPLETED_TASK"
      or line_type == "COMPLETED_TASK_INFO"
      or line_type == "NOTE_TITLE"
      or line_type == "NOTE_BODY"
    then
      goto continue
    end

    if line_type == "PROJECT_TITLE" then
      current_project_index = #projects + 1
      projects[current_project_index] = { title = line, info = {}, tasks = {} }
      goto continue
    end

    if line_type == "PROJECT_INFO" then
      assert(current_project_index ~= nil)
      local info = projects[current_project_index].info
      info[#info + 1] = line
      goto continue
    end

    if current_project_index == nil then
      misc_tasks[#misc_tasks + 1] = line
    else
      local tasks = projects[current_project_index].tasks
      tasks[#tasks + 1] = line
    end
    ::continue::
  end

  for _, task in ipairs(misc_tasks) do
    if #task > 0 then
      lines[#lines + 1] = task
    end
  end
  lines[#lines + 1] = ""

  for _, project in ipairs(projects) do
    lines[#lines + 1] = project.title
    for _, info in ipairs(project.info) do
      if #info > 0 then
        lines[#lines + 1] = info
      end
    end
    for _, task in ipairs(project.tasks) do
      if #task > 0 then
        lines[#lines + 1] = task
      end
    end
    lines[#lines + 1] = ""
  end

  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

vim.keymap.set("n", "<Leader>wx", copy_tasks, { desc = "Copy tasks from previous day" })

-- Binary jump mode
-- local current_jump_type = nil
--
-- local JumpType = { HORIZONTAL = "horizontal", VERTICAL = "vertical" }
-- local JumpDirection = { UP = "up", DOWN = "down", LEFT = "left", RIGHT = "right" }
--
-- local vertical_bounds = {
--   top = nil,
--   bottom = nil,
-- }
--
-- local horizontal_bounds = {
--   left = nil,
--   right = nil,
-- }
--
-- local function reset_vertical_bounds()
--   vertical_bounds = {
--     top = nil,
--     bottom = nil,
--   }
--   vim.cmd('hi clear CursorLine')
-- end
--
-- local function reset_horizontal_bounds()
--   horizontal_bounds = {
--     top = nil,
--     bottom = nil,
--   }
--   vim.wo.colorcolumn = ""
-- end
--
-- local function validate_vertical_jump(jump_direction, current_row)
--   if jump_direction == JumpDirection.UP then
--     if current_row == 1 then
--       return false
--     end
--   elseif jump_direction == JumpDirection.DOWN then
--     if current_row == vim.fn.line("$") then
--       return false
--     end
--   end
--   return true
-- end
--
-- local function validate_horizontal_jump(jump_direction, current_col)
--   if jump_direction == JumpDirection.LEFT then
--     if current_col == 1 then
--       return false
--     end
--   elseif jump_direction == JumpDirection.RIGHT then
--     local end_of_line = vim.fn.col("$")
--     if current_col == end_of_line - 1 or end_of_line == 1 then
--       return false
--     end
--   end
--   return true
-- end
--
-- local function calculate_jump_target(current_location, jump_boundary)
--   print(current_location, jump_boundary)
--   if current_location > jump_boundary then
--     local distance = current_location - jump_boundary
--     return math.floor(current_location - distance * 0.5)
--     -- return math.floor(((current_location + jump_boundary) / 2 ))
--   elseif current_location < jump_boundary then
--     local distance = jump_boundary - current_location
--     return math.floor(current_location + distance * 0.5)
--     -- return math.floor(((current_location + jump_boundary) / 2 ))
--   end 
--   return current_location
-- end
--     
-- local function vertical_jump(jump_direction)
--   local current_row = vim.fn.line(".")
--   local target_row = nil
--
--   if not validate_vertical_jump(jump_direction, current_row) then
--     return reset_vertical_bounds()
--   end
--
--   if jump_direction == JumpDirection.UP then
--     target_row = calculate_jump_target(current_row, vertical_bounds.top or vim.fn.line("w0"))
--     if target_row >= current_row then
--       target_row = target_row - 1
--       vertical_bounds.top = target_row
--       vertical_bounds.bottom = target_row
--     else
--       vertical_bounds.bottom = current_row
--     end
--   elseif jump_direction == JumpDirection.DOWN then
--     target_row = calculate_jump_target(current_row, vertical_bounds.bottom or vim.fn.line("w$"))
--     if target_row <= current_row then
--       target_row = target_row + 1
--       vertical_bounds.top = target_row
--       vertical_bounds.bottom = target_row
--     else
--       vertical_bounds.top = current_row
--     end
--   end
--
--   current_jump_type = JumpType.VERTICAL
--   vim.cmd.normal(target_row.."G")
--   vim.wo.cursorline = true
--   vim.cmd('highlight CursorLine guibg=#333340')
--
-- end
--
-- local function horizontal_jump(jump_direction)
--   local current_col = vim.fn.col(".")
--   local current_row = vim.fn.line(".")
--   local target_col = nil
--
--   if not validate_horizontal_jump(jump_direction, current_col) then
--     return reset_horizontal_bounds()
--   end
--
--   if jump_direction == JumpDirection.LEFT then
--     target_col = calculate_jump_target(current_col, horizontal_bounds.left or 1)
--     if target_col >= current_col then
--       target_col = target_col - 1
--       horizontal_bounds.right = target_col
--       horizontal_bounds.left = target_col
--     else
--       horizontal_bounds.right = current_col
--     end
--   elseif jump_direction == JumpDirection.RIGHT then
--     target_col = calculate_jump_target(current_col, horizontal_bounds.right or vim.fn.col("$"))
--     if target_col <= current_col then
--       target_col = target_col + 1
--       horizontal_bounds.right = target_col
--       horizontal_bounds.left = target_col
--     else
--       horizontal_bounds.left = current_col
--     end
--   end
--   local indent_level = vim.fn.indent(current_row)
--   local tab_count = 0
--   local line = vim.api.nvim_get_current_line()
--   for char_index = 1, #line do
--     if string.sub(line, char_index, char_index) == "\t" then
--       tab_count = tab_count + 1
--     else
--       break
--     end
--   end
--
--   current_jump_type = JumpType.HORIZONTAL
--   vim.cmd.normal("0")
--   if target_col > 1 then
--     vim.cmd.normal(tostring(target_col - 1).."l")
--   end
--   if tab_count > 0 then
--     if target_col >= tab_count then
--       vim.o.colorcolumn = tostring(target_col + indent_level - tab_count)
--     else
--       local spaces_per_tab = indent_level/tab_count
--       vim.o.colorcolumn = tostring(target_col * spaces_per_tab)
--     end
--   else
--     vim.o.colorcolumn = tostring(target_col)
--   end
-- end
--
-- local function jump_up() vertical_jump(JumpDirection.UP) end
-- local function jump_down() vertical_jump(JumpDirection.DOWN) end
-- local function jump_right() horizontal_jump(JumpDirection.RIGHT) end
-- local function jump_left() horizontal_jump(JumpDirection.LEFT) end
--
-- vim.api.nvim_create_autocmd({"CursorMoved", "ModeChanged"}, {
--   group = vim.api.nvim_create_augroup("test-group", { clear = true }),
--   callback = function()
--     if current_jump_type ~= JumpType.HORIZONTAL then 
--       if horizontal_bounds.left ~= nil or horizontal_bounds.right ~= nil then
--         reset_horizontal_bounds()
--       end
--     end
--     if current_jump_type ~= JumpType.VERTICAL then 
--       if vertical_bounds.top ~= nil or vertical_bounds.bottom ~= nil then
--         reset_vertical_bounds()
--       end
--     end
--     current_jump_type = nil
--   end
-- })
-- vim.keymap.set({"n", "o", "v"}, "H", jump_left)
-- vim.keymap.set({"n", "o", "v"}, "J", jump_down)
-- vim.keymap.set({"n", "o", "v"}, "K", jump_up)
-- vim.keymap.set({"n", "o", "v"}, "L", jump_right)
