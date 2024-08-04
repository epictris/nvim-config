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
  end
})
