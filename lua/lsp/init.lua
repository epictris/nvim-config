-- LSP
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>cr', '<cmd>Lspsaga rename<CR>', 'Rename')
    nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    nmap('<leader>lr', require("telescope.builtin").lsp_references, 'List references')
    nmap('_', vim.lsp.buf.hover, 'Hover documentation')
    nmap('<leader>E', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Jump to previous diagnostic')
    nmap('<leader>e', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Jump to next diagnostic')
end

require('neodev').setup()
-- local servers = { 'pyright', 'pylsp', 'lua_ls', 'tsserver', 'eslint' }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = false
local mason_lspconfig = require 'mason-lspconfig'
-- mason_lspconfig.setup {
--     ensure_installed = servers
-- }

local format_ruff = function ()
    local current_file = vim.fn.expand('%:p')
    vim.cmd.w()
    vim.cmd('!python -m ruff --fix '..current_file)
    vim.cmd('!python -m ruff format '..current_file)
end

local format_ts = function ()
    local current_file = vim.fn.expand('%:p')
    vim.cmd.w()
    -- vim.cmd.pwd("main/site")
    vim.cmd('!cd main/site && npx biome format --write '..current_file)
    -- print('!cd main/site && npx biome format --write '..current_file)
    -- vim.cmd.pwd("../..")
end




mason_lspconfig.setup_handlers({
    require('lspconfig')['biome'].setup({
        capabilites = capabilities,
        on_attach = function(client, buffer)
            vim.keymap.set('n', "<C-t>", format_ts)
            on_attach(client, buffer)
        end,
        filetypes = { 'typescript', 'typescriptreact', 'javascriptreact', 'javascript' },
    }),
    -- tsserver config
    require('lspconfig')['tsserver'].setup({
        capabilites = capabilities,
        on_attach = function(client, buffer)
            on_attach(client, buffer)
        end,
        settings = {
            completions = {
                completeFunctionCalls = true
            }
        },
        filetypes = { 'javascriptreact', 'typescript', 'typescriptreact' },
    }),
    -- pyright config
    require('lspconfig')['pyright'].setup({
    	capabilites = capabilities,
    	on_attach = function(client, buffer)
              vim.keymap.set('n', "<C-f>", format_ruff)
            on_attach(client, buffer)
    	end,
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
                                -- exclude = {
                                --     "**/node_modules",
                                --     "**/__pycache__",
                                --     "**/.*",
                                --     -- "**/env",
                                -- }
    			},
    			linting = { pylintEnabled = false }
    		}
    	},
    	filetypes = { 'python' }
    }),


    -- lua_ls config
    require('lspconfig')['lua_ls'].setup({
        capabilites = capabilities,
        on_attach = function(client, buffer)
            on_attach(client, buffer)
        end,
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    }),
})
