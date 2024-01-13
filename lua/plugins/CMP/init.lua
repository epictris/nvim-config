return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'hrsh7th/cmp-nvim-lsp',
		'rafamadriz/friendly-snippets',
	},
	config = function ()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				},
				['<S-CR>'] = (function()
					cmp.mapping.close()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'i', false)
				end)(),
				-- ['<Tab>'] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_next_item()
				-- 	elseif luasnip.expand_or_locally_jumpable() then
				-- 		luasnip.expand_or_jump()
				-- 	else
				-- 		fallback()
				-- 	end
				-- 	end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
					end, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp', keyword_length = 1 },
			},
			view = { docs = {
					auto_open = true
				}
			},
			-- experimental = {
			-- 	ghost_text = true
			-- }

		}
		
	end
}
