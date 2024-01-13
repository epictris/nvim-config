return {
	"sindrets/diffview.nvim",
	config = function ()
		require("diffview").setup({
		})
		vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>", {desc = "open diff view"})
		vim.keymap.set("n", "<leader>dr", function () 
			local ref = vim.fn.input("Ref name: ")
			if ref == "" then
				return
			end
			vim.cmd("DiffviewOpen " .. ref)
		end, {desc = "open ref diff view"})
		vim.keymap.set("n", "<leader>dq", ":DiffviewClose<CR>", {desc = "quit diff view"})
	end
}
