return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text"
	},
	config = function ()
		local dap = require("dap")
		local ui = require("dapui")

		require("dapui").setup()

		dap.adapters.python = {
			type = "server",
			port = "4000",
			executable = {
				command = (os.getenv('VIRTUAL_ENV') or "") .. '/bin/python',
				args = { "-m", "debugpy.adapter", "--port", "4000"}
			}
		}
		dap.configurations.python = {
			{
				type = 'python',
				name = 'Debug Flask',
				request = 'launch',
				program = vim.fn.getcwd() .. "/main/site/flask/flask_main.py"
			},
			{
				type = 'python',
				name = 'Debug Script',
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

		vim.keymap.set("n", "<leader>d1", dap.continue)

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
