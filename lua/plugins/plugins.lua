AYU = {
	"Shatur/neovim-ayu",
	lazy = false,
	priority = 1000,
	config = function ()
		vim.cmd("colorscheme ayu-mirage")
	end
}

BUFFER_MANAGER = {
	"j-morano/buffer_manager.nvim",
	lazy = false,
	priority = 1000,
	config = function ()
		vim.keymap.set('n', '<leader>t', require("buffer_manager.ui").toggle_quick_menu)
	end
}

CMP = {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'hrsh7th/cmp-nvim-lsp',
		'rafamadriz/friendly-snippets',
		'lukas-reineke/cmp-under-comparator',
	},
	config = function ()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}

		local lspkind_comparator = function(conf)
			local lsp_types = require('cmp.types').lsp
			return function(entry1, entry2)
				if entry1.source.name ~= 'nvim_lsp' then
					if entry2.source.name == 'nvim_lsp' then
						return false
					else
						return nil
					end
				end
				local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
				local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

				local priority1 = conf.kind_priority[kind1] or 0
				local priority2 = conf.kind_priority[kind2] or 0
				if priority1 == priority2 then
					return nil
				end
				return priority2 < priority1
			end
		end

		local label_comparator = function(entry1, entry2)
			return entry1.completion_item.label < entry2.completion_item.label
		end

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = {
					col_offset = 4
				}
			},
			mapping = cmp.mapping.preset.insert {
				['<C-d>'] = cmp.mapping.select_next_item(),
				['<C-u>'] = cmp.mapping.select_prev_item(),
				-- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
				-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-n>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				},
			},
			sources = {
				{ name = 'nvim_lsp', keyword_length = 1 },
			},
			view = { docs = {
				auto_open = true
				}
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("cmp-under-comparator").under,
					cmp.config.compare.exact,
					cmp.config.compare.recently_used,
					cmp.config.compare.score,
					lspkind_comparator({
						kind_priority = {
							EnumMember = 13,
							Field = 12,
							Property = 12,
							Class = 11,
							Variable = 11,
							Constant = 10,
							Enum = 10,
							Event = 10,
							Function = 10,
							Method = 10,
							Operator = 10,
							Reference = 10,
							Struct = 10,
							File = 8,
							Folder = 8,
							Color = 5,
							Module = 5,
							Keyword = 2,
							Constructor = 1,
							Interface = 1,
							Snippet = 0,
							Text = 1,
							TypeParameter = 1,
							Unit = 1,
							Value = 1,
						},
					}),
					label_comparator,
				},
			}
		}
	end
}

DIFFVIEW = {
	"sindrets/diffview.nvim",
	config = function ()
		require("diffview").setup({
		})
		vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>", {desc = "open diff view"})
		vim.keymap.set("n", "<leader>dr", function () 
			local ref = vim.fn.input("Ref name: ")
			if ref == "" then
				return
			end
			vim.cmd("DiffviewOpen " .. ref)
			end, {desc = "open ref diff view"})
		vim.keymap.set("n", "<leader>dq", ":DiffviewClose<CR>", {desc = "quit diff view"})
	end
}

DRESSING = {
	"stevearc/dressing.nvim",
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	config = function ()
		require("dressing").setup({
			input = {
				prefer_width = 10
			},
			select = {
				get_config = function(opts)
					if opts.kind == 'codeaction' then
						return {
							backend = 'nui',
							nui = {
								relative = 'editor',
								max_width = 40,
							}
						}
						-- return {
						-- 	backend = {
						-- 		'fzf-lua'
						-- 	}
						-- }
					else
						return {
							backend = {
								'fzf-lua'
							}
						}
					end
				end
			},
		})
	end
}


GITSIGNS =  { "lewis6991/gitsigns.nvim",
	config = function ()
		require("gitsigns").setup({
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				delay = 300
			},
			on_attach = function ()
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "<C-s>", function()
					if vim.wo.diff then return ']c' end
					vim.schedule(gs.next_hunk)
					return '<Ignore>'
					end, { expr = true, desc = "jump to next diff"})

				vim.keymap.set("n", "<C-c>", function()
					if vim.wo.diff then return '[c' end
					vim.schedule(gs.prev_hunk)
					return '<Ignore>'
					end, { expr = true, desc = "jump to last diff"})

				vim.keymap.set("n", "<leader>hs", function () gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, {desc = "stage hunk"})
				vim.keymap.set("n", "<leader>hS", gs.stage_buffer, {desc = "stage buffer"})
				vim.keymap.set("n", "<leader>hr", function () gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, {desc = "reset hunk"})
				vim.keymap.set("n", "<leader>hR", gs.reset_buffer, {desc = "reset buffer"})
				vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, {desc = "undo stage hunk"})
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, {desc = "preview hunk"})
				vim.keymap.set("n", "<leader>hd", gs.diffthis, {desc = "open diff of current file"})
			end
		})
	end
}

GIT_BLAME = {
	"f-person/git-blame.nvim",
	config = function ()
		require("gitblame").setup({
			enabled = true,
		})
		vim.g.gitblame_message_template = '<author> • <date> • <summary>'
		vim.g.gitblame_date_format = '%r: %x'
		vim.g.gitblame_virtual_text_column = 90
		vim.g.gitblame_delay = 0
		vim.keymap.set("n", "<leader>gb", ":GitBlameOpenCommitURL<CR>", { desc = "Open commit hash of current line in Github" })
		vim.keymap.set("n", "<leader>gxf", ":GitBlameCopyFileURL<CR>", { desc = "Copy GitHub url of current file" })
		vim.keymap.set("n", "<leader>gxh", ":GitBlameCopySHA<CR>", { desc = "Copy commit hash of current line" })
	end
}

HARPOON =  {
	'ThePrimeagen/harpoon',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function ()
		local buffer_width = vim.api.nvim_win_get_width(0)
		local menu_width = (buffer_width < 120 and buffer_width or 120) - 20
		require("harpoon").setup({
			menu = {
				width = menu_width
			}
		})
		-- File Marks
		vim.keymap.set("n", "<leader>m", require("harpoon.mark").add_file, {desc="Mark file"})
		vim.keymap.set("n", "<leader>M", require("harpoon.ui").toggle_quick_menu, {desc="View marked files"})
		vim.keymap.set("n", "<leader>1", (function() require("harpoon.ui").nav_file(1) end), {desc="Go to mark 1"})
		vim.keymap.set("n", "<leader>2", (function() require("harpoon.ui").nav_file(2) end), {desc="Go to mark 2"})
		vim.keymap.set("n", "<leader>3", (function() require("harpoon.ui").nav_file(3) end), {desc="Go to mark 3"})
		vim.keymap.set("n", "<leader>4", (function() require("harpoon.ui").nav_file(4) end), {desc="Go to mark 4"})
		vim.keymap.set("n", "<leader>5", (function() require("harpoon.ui").nav_file(4) end), {desc="Go to mark 5"})
	end
}

INDENT_BLANKLINE = {
	"lukas-reineke/indent-blankline.nvim",
	config = function ()
		require("ibl").setup({
			indent = { 	char = '│', }
		})
	end
}

LAZYDEV = {
	"folke/lazydev.nvim",
	ft = "lua", -- only load on lua files
	opts = {
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},
}

LSPSAGA = {
	"glepnir/lspsaga.nvim",
	config = function ()
		require("lspsaga").setup({})
	end
}

LUALINE = {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'ThePrimeagen/harpoon',
	},
	config = function ()
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

MARKDOWN_PREVIEW = {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}

MINI_AI = {
	"echasnovski/mini.ai",
	config = function ()
		require('mini.ai').setup()
	end
}

MINI_INDENTSCOPE = {
	"echasnovski/mini.indentscope",
	config = function ()
		require 'mini.indentscope'.setup({
			draw = {
				delay = 0,
				animation = require('mini.indentscope').gen_animation.none()
			},
			symbol = '│'
		})
	end
}

MINI_OPERATORS = {
	"echasnovski/mini.operators",
	config = function ()
		require 'mini.operators'.setup({
			exchange = {
				prefix = 'cx'
			},
			replace = {
				prefix = '<leader>r'
			}
		})
	end
}

NEOGIT = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim"
	},
	config = function ()
		require('neogit').setup({})
		vim.keymap.set('n', '<leader>N', require('neogit').open)
	end

}

NOICE = { 
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	config = function()
		require('noice').setup({
			cmdline = {
				enabled = true,
				view = "cmdline"
			},
			messages = {
				enabled = true,
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				popup = {
					opts = {
						border = {
							style = "rounded",
						}
					}
				},
				hover = {
					enabled = true,
					silent = false,
					view = nil,
					opts = {
						relative = "cursor",
						position = { row = 2, col = 0 },
						size = {
							width = "auto",
							height = "auto",
							max_height = 20,
							max_width = 120,
						},
						border = {
							style = "rounded",
							padding = {0, 0}
						}
					}
				}
			},
		})
		vim.keymap.set("n", "<leader>sm", ":Noice<CR>", {desc="(s)how (m)essages"})
	end
}

NVIM_BQF = {
	"kevinhwang91/nvim-bqf",
}

ACTIONS_PREVIEW = {
	"aznhe21/actions-preview.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("actions-preview").setup({
			backend = {"nui"},
			nui = {
				layout = {
					size = {
						width = "30%",
						height = "30%"
					}
				},
				preview = {
					size = "75%",
				},
				select = {
					size  = "25%",
				}
			}
		})
		vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
	end,
}

TINY_CODE_ACTION = {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{"nvim-lua/plenary.nvim"},

		-- optional picker via telescope
		{"nvim-telescope/telescope.nvim"},
		-- optional picker via fzf-lua
		{"ibhagwan/fzf-lua"},
		-- .. or via snacks
		{
			"folke/snacks.nvim",
			opts = {
				terminal = {},
			}
		}
	},
	event = "LspAttach",
	opts = {},
	config = function () 
		require("tiny-code-action").setup({
			backend = "vim",
			picker = "telescope",
		})
		vim.keymap.set({"n"}, '<leader>co', require("tiny-code-action").code_action, {desc='Code Action'})
	end

}


NVIM_DAP = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio"
	},
	config = function ()
		local dap = require("dap")
		local ui = require("dapui")

		dap.set_log_level('INFO')

		require("dapui").setup()

		-- dap.adapters.python = {
		-- 	type = "server",
		-- 	port = "4000",
		-- 	executable = {
		-- 		command = (os.getenv('VIRTUAL_ENV') or "") .. '/bin/python',
		-- 		args = { "-m", "debugpy.adapter", "--port", "4000"}
		-- 	}
		-- }
		-- dap.adapters.example = {
		-- 	type = "executable",
		-- 	command = '/Users/tris/unc/master/env/bin/python3.12',
		-- 	args = { "-m", "debugpy.adapter"},
		-- }
		--
		-- dap.configurations.python = {
		-- 	{
		-- 		type = 'example',
		-- 		name = 'Debug',
		-- 		request = 'launch',
		-- 		program = "/Users/tris/unc/master/main/site/flask/flask_main.py",
		-- 	},
		-- }
		dap.adapters.uncountable_server = {
			type = "server",
			port = "${port}",
			executable = {
				command = "/bin/sh",
				args = {"-c", 'UNC_INDIGO_ENABLED=true UNC_PRINT_EMAILS=true UNC_RDKIT_ENABLED=true LAZY_LOAD_ROUTES=true SOCKETS_ENABLED=true LOCAL_WARNINGS=true SQLALCHEMY_WARN_20=1 AWS_REGION="us-west-2" AWS_SECRET_ANTHROPIC_KEY="ANTHROPIC_API_KEY" AWS_SECRET_OPENAI_API_KEY="OPENAI_API_KEY_PLAYGROUND" SSL_CRT="../../werkzeug_ssl.crt" SSL_KEY="../../werkzeug_ssl.key" python3.12 -m debugpy.adapter --port ${port}'},
			}
		}
		dap.adapters.python = {
			type = "executable",
			command = (os.getenv("VIRTUAL_ENV") or "") .. "/bin/python3.12",
			args = {"-m", "debugpy.adapter"}
		}
		dap.configurations.python = {
			{
				type = 'uncountable_server',
				name = 'Uncountable',
				request = 'launch',
				program = vim.fn.getcwd() .. "/main/site/flask/flask_main.py"
			},
			{
				type = 'python',
				name = 'File',
				request = 'launch',
				program = "${file}"
			}
		}
		-- if python_adapter ~= "" then
		-- 	dap.adapters.python = {
		-- 		type = "executable",
		-- 		command = python_adapter
		-- 	}
		-- 	dap.configurations.python = {
		-- 		{
		-- 			type = "python",
		-- 			name = "Launch Task",
		-- 			request = "launch",
		-- 			program = "${file}",
		-- 			pythonPath = "${workspaceFolder}",
		-- 		}
		-- 	}
		-- end

		-- the adapter is the executable debugger that steps through the program & communicate with the nvim dap protocol
		-- configuration is the settings applied to the debugger

		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>dr", dap.run_to_cursor)

		vim.keymap.set("n", "<leader>dc", dap.continue)
		vim.keymap.set("n", "<leader>dq", function() dap.close() ui.close() end)

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end
}

NVIM_LSPCONFIG = {
	'neovim/nvim-lspconfig',
	dependencies = {
		{
			'williamboman/mason.nvim',
			config = true
		},
		'williamboman/mason-lspconfig.nvim',
		{
			'j-hui/fidget.nvim',
			tag = 'legacy',
			opts = {}
		}
	},
	config = function ()
		vim.lsp.config("biome", {
			filetypes = { 'typescript', 'typescriptreact', 'javascriptreact', 'javascript' },
		})

		vim.lsp.config("tsserver", {
			settings = {
				completions = {
					completeFunctionCalls = true
				}
			},
			filetypes = { 'javascriptreact', 'typescript', 'typescriptreact' },
		})

		vim.lsp.config("pyright", {
			settings = {
				pyright = {
					disableOrganizeImports = true
				},
				python = {
					analysis = {
						useLibraryCodeForTypes = false,
						autoImportCompletions = true,
						diagnosticMode = 'openFilesOnly',
						typeCheckingMode = 'basic',
						exclude = {
							"**/node_modules",
							"**/__pycache__",
							"**/env",
						}
					},
					linting = { pylintEnabled = false }
				}
			},
			filetypes = { 'python' }
		})

		vim.lsp.config("omnisharp", {
			settings = {},
			cmd = { "dotnet", "/home/tris/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll"},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
		})

		vim.lsp.config["splints"] = {
			cmd = { "splints" },
			filetypes = { "python" },
			automatic_enable = true,
		}


		local mason_lspconfig = require('mason-lspconfig').setup({
			ensure_installed = {
				'biome',
				'pyright',
				'tsserver',
				'omnisharp',
				'lua_ls',
				'splints',
			},
		})

		vim.lsp.enable({"splints", "lua_ls", "pyright", "tsserver", "omnisharp", "biome"})

	end
}

OIL = {
	'stevearc/oil.nvim',
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require('oil')
		oil.setup({
			default_file_explorer = false,
			cleanup_delay_ms = 0,
			delete_to_trash = true,
			skip_confirm_for_files = true,
			view_options = {
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, "..")
				end
			}
		})
		vim.keymap.set('n', '-',
			function()
				oil.open()
				require('oil.util').run_after_load(0, function()
					oil.open_preview()
				end)
			end,
			{ desc = "Open Parent Directory" }
		)
	end,
}

OMNISHARP_EXTENDED = {
	'Hoffs/omnisharp-extended-lsp.nvim'
}

SUPERMAVEN = {
	"supermaven-inc/supermaven-nvim",
	config = function ()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-l>"
			},
			ignore_filetypes = { markdown = true },
		})
	end
}

TELESCOPE = {
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
		local nmap = function(keys, func, desc)
			if desc then
				desc = desc
			end
			vim.keymap.set('n', keys, func, { desc = desc })
		end
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
		nmap("<leader>gc", function() builtin.git_bcommits(picker_dropdown()) end, "Git commits")
		nmap("<leader>gd", function() builtin.git_status(picker_dropdown()) end, "Changed files")

		-- LSP
		nmap("gd", function() builtin.lsp_definitions(picker_dropdown()) end, "(g)o to (d)efinition")
		nmap("gr", function() builtin.lsp_references(picker_dropdown()) end, "(g)o to (r)eferences")
		nmap("gt", function() builtin.lsp_type_definitions(picker_dropdown()) end, "(g)o to (t)ype defintion")
	end,
}

TREESITTER = {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	config = function ()
		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = {
					enable = false,
				},
				move = {
					enable = false
				},
				swap = {
					enable = false,
				}
			},
			ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
				'markdown', 'markdown_inline', 'cmake' , 'bash'},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = "v",
					node_decremental = "V",
				},
			},
		}
	end
}

VIM_BE_GOOD = {
	'ThePrimeagen/vim-be-good'
}

VIM_SLEUTH = {
	"tpope/vim-sleuth"
}

VIM_SNEAK = {
	"justinmk/vim-sneak",
	config = function()
		vim.keymap.set({'n', 'v'}, 'f', '<Plug>Sneak_f', {})
		vim.keymap.set({'n', 'v'}, 'F', '<Plug>Sneak_F', {})
		vim.keymap.set({'n', 'v'}, 't', '<Plug>Sneak_t', {})
		vim.keymap.set({'n', 'v'}, 'T', '<Plug>Sneak_T', {})
	end,
}

WHICH_KEY = {
	"folke/which-key.nvim",
	opts = {},
}

return {
	AYU,
	ACTIONS_PREVIEW,
	BUFFER_MANAGER,
	CMP,
	-- DIFFVIEW,
	DRESSING,
	GITSIGNS,
	GIT_BLAME,
	HARPOON,
	INDENT_BLANKLINE,
	LAZYDEV,
	LSPSAGA,
	LUALINE,
	MARKDOWN_PREVIEW,
	MINI_AI,
	MINI_INDENTSCOPE,
	MINI_OPERATORS,
	NEOGIT,
	NOICE,
	NVIM_BQF,
	NVIM_DAP,
	NVIM_LSPCONFIG,
	OIL,
	OMNISHARP_EXTENDED,
	SUPERMAVEN,
	TELESCOPE,
	TINY_CODE_ACTION,
	TREESITTER,
	VIM_BE_GOOD,
	VIM_SLEUTH,
	VIM_SNEAK,
	WHICH_KEY
}
