vim.g.mapleader = " "

vim.g.clipboard = { 
	name = "myClipboard",
	copy = {
		['+'] = {"clip.exe"},
		['*'] = {"clip.exe"},
	},
	paste = {
		['+'] = {"clip.exe"},
		['*'] = {"clip.exe"},
	},
}

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


-- Recentre after page up/down and jump to search
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")

-- Make file executable
nmap("<leader>cx", ":!chmod +x %<CR>", {desc="make file executable"})

-- Easy paste from yank buffer
nmap("<leader>p", '"0p')

-- Easy yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')

-- Easy vertical/horizontal split
nmap("<leader>|", vim.cmd.vsplit)
nmap("<leader>_", vim.cmd.split)

-- LSP keymaps
nmap('<leader>cr', vim.lsp.buf.rename, {desc='Rename'})
nmap('_', vim.lsp.buf.hover, {desc='Hover documentation'})

nmap('<leader>E', vim.diagnostic.goto_prev, {desc='Jump to previous diagnostic'})
nmap('<leader>e', function() vim.diagnostic.goto_next() vim.lsp.buf.code_action() end, {desc='Jump to next diagnostic'})


vim.g["sneak#s_next"] = 1
-- vim.o.statuscolumn = "%l %=%{v:relnum?v:relnum:v:lnum} "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.incsearch = true
vim.o.hlsearch = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.number = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.opt.termguicolors = true
vim.o.splitright = true
vim.o.ts = 4
vim.o.sw = 4
vim.o.wrap = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.updatetime = 250
vim.o.cursorline = true
vim.o.swapfile = false
vim.diagnostic.config({
	signs = true,
	underline = true,
	virtual_text = false,
	virtual_lines = false,
	update_in_insert = true,
	float = {
		header = "",
		border = 'rounded',
		focusable = true,
	}
})
vim.o.guicursor="i:ver25"
vim.o.linebreak = true


-- vim.lsp.set_log_level('DEBUG')
vim.lsp.set_log_level('INFO')

require("plugins")
require("autocmds")
require("post_init")

-- vim.lsp.set_log_level('TRACE')

-- vim.notify("Starting client")
--
-- local client = vim.lsp.start_client({name="splints", cmd= {"splints"}})
--
--
-- if not client then
--     vim.notify("Failed to start client")
--     return
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "python",
-- 	callback = function()
-- 		vim.lsp.buf_attach_client(0, client)
-- 	end
-- })
