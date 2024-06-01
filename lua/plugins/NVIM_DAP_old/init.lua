function close_dap()
	local dap = require("dap")
	local ui = require("dapui")
	dap.clear_breakpoints()
	ui.toggle({})
	dap.terminate()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
end

function open_dap()
	local dap = require("dap")
	local ui = require("dapui")
	dap.continue()
	ui.toggle()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
	vim.keymap.set("n", "<leader>D", close_dap)
end



return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text"
	},
	config = function ()
		local ui = require("dapui")
		ui.setup({
		  icons = { expanded = "▾", collapsed = "▸" },
		 --  mappings = {
			-- open = "o",
			-- remove = "d",
			-- edit = "e",
			-- repl = "r",
			-- toggle = "t",
		 --  },
		  expand_lines = vim.fn.has("nvim-0.7"),
		  layouts = {
			{
			  elements = {
				"scopes",
			  },
			  size = 0.3,
			  position = "right"
			},
			{
			  elements = {
				"repl",
				"breakpoints"
			  },
			  size = 0.3,
			  position = "bottom",
			},
		  },
		  floating = {
			max_height = nil,
			max_width = nil,
			border = "single",
			mappings = {
			  close = { "q", "<Esc>" },
			},
		  },
		  windows = { indent = 1 },
		  render = {
			max_type_length = nil,
		  },
		})

		local dap = require("dap")
		dap.set_log_level('INFO')
		dap.adapters.python = {
			type = "server",
			port = "4000",
				executable = {
				command = (os.getenv('VIRTUAL_ENV') or "") .. '/bin/python',
				args = { (os.getenv('VIRTUAL_ENV') or "") .. "/lib/python3.11/site-packages/debugpy/adapter", "--port", "4000"}
			}
		}
		dap.configurations.python = {
				{
					type = 'python',
					name = 'Debug',
					request = 'launch',
					program = vim.fn.getcwd() .. "/main/site/flask/flask_main.py"
				}
		}
		
		vim.keymap.set("n", "<leader>D", open_dap)

		-- Set breakpoints, get variable values, step into/out of functions, etc.
		vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover)
		vim.keymap.set("n", "<leader>dc", dap.continue)
		vim.keymap.set("n", "<leader>bt", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>so", dap.step_over)
		vim.keymap.set("n", "<leader>si", dap.step_into)
		vim.keymap.set("n", "<leader>sO", dap.step_out)
		vim.keymap.set("n", "<leader>bC", dap.clear_breakpoints)
		 
	end
}
