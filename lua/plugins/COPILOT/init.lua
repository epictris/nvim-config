return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function ()
		require("copilot").setup({
			panel = {
				enabled = false
			},
			suggestion = {
				auto_trigger = true,
				debounce = 200,
				keymap = {
					accept = "<C-y>",
				}
			},
			server_opt_overrides = {
				trace = "OFF",
				settings = {
					advanced = {
						inlineSuggestions = 1,
					}
				}
			}
		})
	end
}
