local nmap = function(keys, func, desc)
	if desc then
desc = desc
	end
	vim.keymap.set('n', keys, func, { desc = desc })
end


return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		"nvim-telescope/telescope-live-grep-args.nvim",
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function ()
		local lga_actions = require('telescope-live-grep-args.actions')
		local builtin = require('telescope.builtin')
		local layout_config = {
				preview_cutoff = 1, -- Preview should always show (unless previewer = false)

				width = function(_, max_columns, _)
					return math.min(max_columns, 160)
				end,

				height = function(_, _, max_lines)
					return math.min(max_lines, 15)
				end,
		}
		local picker_dropdown = function(args)
			args = args or {}
			local cwd = args.cwd or vim.fn.getcwd()
			return require('telescope.themes').get_dropdown({cwd = cwd, layout_config=layout_config})
		end
		require('telescope').setup({
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				}
			}
		})

		pcall(require('telescope').load_extension, 'fzf')

		nmap("?", function() builtin.current_buffer_fuzzy_find(picker_dropdown()) end)
		-- Buffer Navigation
		nmap('<leader>sb', function() builtin.buffers(picker_dropdown()) end, 'Session buffers')

		-- File Navigation
		nmap("<leader>ft", function() builtin.find_files(picker_dropdown({ cwd = vim.fn.expand('%:h') })) end, "(f)iles in (t)his directory")
		nmap("<leader>fr", function() builtin.find_files(picker_dropdown()) end, "(f)iles in (r)oot directory")
		nmap("<leader>fo", function() builtin.oldfiles(picker_dropdown()) end, "(f)iles in (o)ldfiles list")

		-- Text Search
		nmap("<leader>sw", function() builtin.grep_string(picker_dropdown()) end, "(s)earch for (w)ord under cursor in root directory")
		nmap("<leader>sr", function() require('telescope').extensions.live_grep_args.live_grep_args(picker_dropdown()) end, "(s)earch text in (r)oot directory")
		nmap("<leader>st", function() builtin.live_grep(picker_dropdown({ cwd = vim.fn.expand('%:h') })) end, "(s)earch text in (t)his directory")

		-- Git
		nmap("<leader>gs", function() builtin.git_stash(picker_dropdown()) end, "Git stash")
		nmap("<leader>gc", function() builtin.git_bcommits(picker_dropdown()) end, "Git git commits")
		nmap("<leader>gd", function() builtin.git_status(picker_dropdown()) end, "Changed files")

		-- LSP
		nmap("gd", function() builtin.lsp_definitions(picker_dropdown()) end, "(g)o to (d)efinition")
		nmap("gr", function() builtin.lsp_references(picker_dropdown()) end, "(g)o to (r)eferences")
		nmap("gt", function() builtin.lsp_type_definitions(picker_dropdown()) end, "(g)o to (t)ype defintion")
	end,
}
