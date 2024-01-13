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
  local servers = { 'pyright', 'pylsp', 'lua_ls', 'tsserver', 'eslint' }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = false
  local mason_lspconfig = require 'mason-lspconfig'
  mason_lspconfig.setup {
      ensure_installed = servers
  }

  local venv_path = os.getenv('VIRTUAL_ENV')
  local py_path = nil
  -- decide which python executable to use for mypy
  if venv_path ~= nil then
    py_path = venv_path .. "/bin/python3"
  else
    py_path = vim.g.python3_host_prog
  end

  print(py_path)

  mason_lspconfig.setup_handlers({
      require('lspconfig')['eslint'].setup({
          capabilites = capabilities,
          on_attach = function(client, buffer)
              on_attach(client, buffer)
          end,
          settings = {
              editor = {
                  codeActionsOnSave = {
                      { source = { fixAll = true } } }
              }
          },
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
      		on_attach(client, buffer)
      	end,
      	settings = {
      		pyright = {
      			disableOrganizeImports = true
      		},
      		python = {
      			analysis = {
      				useLibraryCodeForTypes = true,
      				autoImportCompletions = true,
      				diagnosticMode = 'openFilesOnly',
      				typeCheckingMode = 'basic',
      			},
      			linting = { pylintEnabled = true }
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
