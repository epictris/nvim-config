return { "lewis6991/gitsigns.nvim",
	config = function ()
		require("gitsigns").setup({
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				delay = 300
			},
			on_attach = function ()
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "<C-s>", function()
					if vim.wo.diff then return ']c' end
					vim.schedule(gs.next_hunk)
					return '<Ignore>'
				end, { expr = true, desc = "jump to next diff"})

				vim.keymap.set("n", "<C-c>", function()
					if vim.wo.diff then return '[c' end
					vim.schedule(gs.prev_hunk)
					return '<Ignore>'
				end, { expr = true, desc = "jump to last diff"})

				vim.keymap.set("n", "<leader>hs", function () gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, {desc = "stage hunk"})
				vim.keymap.set("n", "<leader>hS", gs.stage_buffer, {desc = "stage buffer"})
				vim.keymap.set("n", "<leader>hr", function () gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, {desc = "reset hunk"})
				vim.keymap.set("n", "<leader>hR", gs.reset_buffer, {desc = "reset buffer"})
				vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, {desc = "undo stage hunk"})
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, {desc = "preview hunk"})
				vim.keymap.set("n", "<leader>hd", gs.diffthis, {desc = "open diff of current file"})
			end
		})
	end
}

