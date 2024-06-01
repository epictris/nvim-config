return {
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
