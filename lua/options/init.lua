vim.g["sneak#s_next"] = 1
vim.o.incsearch = 1
vim.o.hlsearch = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.opt.termguicolors = true
vim.o.ts = 4
vim.o.sw = 4
vim.o.wrap = 'wrap'
vim.o.smartindent = 'si'
vim.o.autoindent = 'autoindent'
vim.o.updatetime = 250
vim.o.cursorline = 1
vim.o.swapfile = false
vim.diagnostic.config({
	virtual_text = false
})
vim.o.guicursor="i:ver25"
-- vim.cmd("autocmd OptionSet guicursor noautocmd set guicursor=")


