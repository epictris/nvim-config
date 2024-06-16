return {
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
