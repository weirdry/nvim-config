-- Language-specific file format settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	command = "setlocal tabstop=4 shiftwidth=4 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	command = "setlocal tabstop=4 shiftwidth=4 noexpandtab",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "proto",
	command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "terraform", "hcl" },
	command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

-- Rust configuration
local rust_augroup = vim.api.nvim_create_augroup("RustConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = rust_augroup,
	pattern = "rust",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
		vim.opt_local.textwidth = 100
		vim.opt_local.colorcolumn = "100"
		if vim.fn.line("$") > 5000 then
			vim.treesitter.stop(0)
			vim.notify("Large Rust file detected, disabling TreeSitter highlights for performance")
		end
		vim.lsp.log.set_level("WARN")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = rust_augroup,
	pattern = "toml",
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

-- Go auto-formatting
local go_augroup = vim.api.nvim_create_augroup("GoFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_augroup,
	pattern = "*.go",
	callback = function()
		require("go.format").goimport()
	end,
})

-- Terminal configuration
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	end,
})

-- Performance optimization
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand("%"))
		if file_size > 1024 * 1024 then
			vim.cmd("syntax off")
			vim.treesitter.stop(0)
			vim.notify("Large file detected, disabling syntax for performance")
		end
	end,
})

-- Config file optimization
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = vim.fn.stdpath("config") .. "/init.lua",
	callback = function()
		vim.cmd("LspStop")
		vim.treesitter.stop(0)
		vim.notify("Config file opened with limited features to prevent freezing")
	end,
})

-- Project-specific spell check words from .vscode/settings.json
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	callback = function()
		local function find_vscode_settings()
			local current_dir = vim.fn.expand("%:p:h")
			while current_dir ~= "/" do
				local vscode_file = current_dir .. "/.vscode/settings.json"
				if vim.fn.filereadable(vscode_file) == 1 then
					return vscode_file
				end
				current_dir = vim.fn.fnamemodify(current_dir, ":h")
			end
			return nil
		end

		local vscode_settings = find_vscode_settings()
		if vscode_settings then
			local ok, content = pcall(vim.fn.readfile, vscode_settings)
			if ok then
				local json_str = table.concat(content, "\n")
				local words_match = json_str:match('"cSpell%.words"%s*:%s*%[([^%]]+)%]')
				if words_match then
					local custom_words = {}
					for word in words_match:gmatch('"([^"]+)"') do
						table.insert(custom_words, word)
					end

					if #custom_words > 0 then
						local project_root = vim.fn.fnamemodify(vscode_settings, ":h:h")
						local spell_dir = project_root .. "/.nvim/spell"
						vim.fn.mkdir(spell_dir, "p")

						local spell_file = spell_dir .. "/project.utf-8.add"
						local file = io.open(spell_file, "w")
						if file then
							for _, word in ipairs(custom_words) do
								file:write(word .. "\n")
							end
							file:close()
							vim.opt_local.spellfile = spell_file
						end
					end
				end
			end
		end
	end,
})

-- User-defined commands
vim.api.nvim_create_user_command("RustNewProject", function(opts)
	local project_name = opts.args
	if project_name == "" then
		project_name = vim.fn.input("Project name: ")
	end
	if project_name == "" then
		return
	end
	local cmd = string.format("cargo new %s", project_name)
	vim.fn.system(cmd)
	vim.cmd(string.format("cd %s", project_name))
	vim.cmd("e Cargo.toml")
	vim.notify(string.format("Created new Rust project: %s", project_name))
end, { nargs = "?" })

-- Debugger configuration
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

local dap = require("dap")
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
		args = { "--port", "${port}" },
	},
}
dap.configurations.rust = {
	{
		name = "Launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
	{
		name = "Launch (with args)",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			return vim.split(args_string, " ")
		end,
	},
}

-- Diagnostic display configuration
vim.diagnostic.config({
	virtual_text = { prefix = "●", source = "always", spacing = 4 },
	float = { source = "always", border = "rounded", header = "", prefix = "" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀦",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
	},
	underline = true,
	severity_sort = true,
})

-- Markdown preview configuration
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_browser = ""
vim.g.mkdp_echo_preview_url = 0
vim.g.mkdp_page_title = "${name}"

-- Python file type recognition
vim.filetype.add({ extension = { py = "python" } })
