-- vim.api.nvim_create_autocmd('FileType', {
-- 	pattern = 'markdown',
-- 	group = vim.api.nvim_create_augroup('md_only_keymap', { clear = true }),
-- 	callback = function ()
-- 		local buf = vim.api.nvim_get_current_buf()
-- 		local wk = require("which-key")
-- 		wk.register({
-- 			["<C-s>"] = { "<Cmd>VimwikiDiaryPrevDay<CR>", "Next Diary", buffer=buf },
-- 			["<C-e>"] = { "<Cmd>VimwikiDiaryNextDay<CR>", "Next Diary", buffer=buf }
-- 		})
-- 	end
-- })
--
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = function(args)
    local oil = require("oil")
    vim.keymap.set("n", "-", function() oil.close() end, { buffer = args.data.buf })
    vim.keymap.set("n", "<Right>", function() oil.select() end, { buffer = args.data.buf })
    vim.keymap.set("n", "<Left>",
      function()
	vim.cmd.pc()
	oil.open()
	require('oil.util').run_after_load(0,
	  function()
		oil.open_preview()
	  end
	)
      end,
  { buffer = args.data.buf })
 --    vim.keymap.set("n", "<Up>",
 --      function()
	-- vim.api.nvim_feedkeys("k", "n", true)
	-- local entry = oil.get_cursor_entry()
	-- local size = (((entry or {}).meta or {}).stat or {}).size or 0
	-- if size < 10000 then
	--   oil.open_preview()
	-- end
 --      end,
 --  { buffer = args.data.buf })
  end
})
