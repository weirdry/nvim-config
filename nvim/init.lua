-- ~/.config/nvim/init.lua

-- Lazy.nvim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require("config.options")
require("lazy").setup("plugins")
require("config.lsp")
require("config.linting")
require("config.autocmds")
require("config.keymaps")
