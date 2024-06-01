local function cwd()
      return vim.fn.getcwd()
end

local function harpoon_status()
	local filename = vim.fn.expand("%")
	local marks = require("harpoon").get_mark_config()['marks']
	for i, mark in ipairs(marks) do
		if mark['filename'] == filename then
			return 'MARK ' .. i
		end
	end
    return ''
end

return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'ThePrimeagen/harpoon',
	},
	config = function ()
		local custom_theme = require('lualine.themes.auto')
		custom_theme.normal.x = { bg = '#ffcc66' , fg = '#0E1019', gui='bold' }
		require('lualine').setup({
			options = {
				theme = custom_theme,
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { cwd, 'filename'},
				lualine_x = { harpoon_status },
				lualine_y = { 'encoding', 'fileformat', 'filetype' },
				lualine_z = { 'location' },
			},
		})
	end
}
