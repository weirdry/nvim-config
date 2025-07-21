-- ~/.config/nvim/init.lua

-- Lazy.nvim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Basic Settings (Options)
-- =============================================================================
vim.g.mapleader = " "
vim.o.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false

-- =============================================================================
-- Helper Functions
-- =============================================================================
-- Check if project files exist
local function has_project_files(files, root_dir)
	root_dir = root_dir or vim.fn.getcwd()
	for _, file in ipairs(files) do
		if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
			return true
		end
	end
	return false
end

-- Detect project type
local function detect_project_type(root_dir)
	root_dir = root_dir or vim.fn.getcwd()

	local frontend_files = { "package.json", "tsconfig.json", "tailwind.config.js", "tailwind.config.ts" }
	local backend_files = { "nest-cli.json", "tsconfig.build.json" }
	local cdk_files = { "cdk.json" }
	local eslint_files =
		{ "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
	local prettier_files =
		{ ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yml", "prettier.config.js" }
	local python_files = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".python-version" }

	return {
		is_frontend = has_project_files(frontend_files, root_dir),
		is_backend = has_project_files(backend_files, root_dir),
		is_cdk = has_project_files(cdk_files, root_dir),
		has_eslint = has_project_files(eslint_files, root_dir),
		has_prettier = has_project_files(prettier_files, root_dir),
		has_python = has_project_files(python_files, root_dir),
	}
end

-- =============================================================================
-- Plugin Management (Lazy.nvim)
-- =============================================================================
require("lazy").setup({
	-- Theme and UI
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					separator_style = "thin",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local s = " "
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and " " or (e == "warning" and " " or " ")
							s = s .. n .. sym
						end
						return s
					end,
					indicator = { style = "underline" },
					show_buffer_close_icons = true,
					show_close_icon = true,
					enforce_regular_tabs = true,
					show_duplicate_prefix = true,
					tab_size = 18,
					padding = 1,
					hover = { enabled = true, delay = 200, reveal = { "close" } },
				},
				highlights = {
					indicator_selected = { fg = "#89b4fa", bg = "#1a1b26", underline = true, sp = "#89b4fa" },
				},
			})
		end,
	},
	{
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("nvim-navic").setup({
				icons = {
					File = "󰈙 ",
					Module = " ",
					Namespace = "󰌗 ",
					Package = " ",
					Class = "󰌗 ",
					Method = "󰆧 ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = "󰕘",
					Interface = "󰕘",
					Function = "󰊕 ",
					Variable = "󰆧 ",
					Constant = "󰏿 ",
					String = "󰀬 ",
					Number = "󰎠 ",
					Boolean = "◩ ",
					Array = "󰅪 ",
					Object = "󰅩 ",
					Key = "󰌋 ",
					Null = "󰟢 ",
					EnumMember = " ",
					Struct = "󰌗 ",
					Event = " ",
					Operator = "󰆕 ",
					TypeParameter = "󰊄 ",
				},
				lsp = { auto_attach = true },
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
				lazy_update_context = false,
				click = true,
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("barbecue").setup({
				theme = {
					normal = { fg = "#a9b1d6", bg = "#16161e" },
					context = { fg = "#a9b1d6", bg = "#16161e" },
					basename = { fg = "#a9b1d6", bg = "#16161e", bold = true },
					dirname = { fg = "#737aa2", bg = "#16161e" },
					separator = { fg = "#565f89", bg = "#16161e" },
					modified = { fg = "#ff9e64", bg = "#16161e" },
				},
				include_buftypes = { "" },
				exclude_filetypes = { "gitcommit", "toggleterm" },
				show_modified = true,
				show_dirname = true,
				show_basename = true,
			})
		end,
	},
	{ "kyazdani42/nvim-web-devicons" },

	-- LSP, auto-completion, and tool installation
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason").setup()
			-- Completely disable mason-lspconfig to prevent auto-starting LSP servers
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Python tools
					"black",
					"isort",
					"ruff",
					-- TypeScript / JavaScript tools
					"prettier",
					"eslint_d",
					-- Go tools
					"gopls",
					"golangci-lint",
					"gofumpt",
					"goimports",
					-- Rust tools (rustfmt installed via rustup)
					"codelldb",
					-- other tools
					"stylua",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" } },

	-- File exploration and search
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "SmiteshP/nvim-navic" },
		config = function()
			require("telescope").setup({
				defaults = {
					winbar = {
						enable = true,
						name_formatter = function(entry)
							return require("nvim-navic").get_location()
						end,
					},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				filters = {
					dotfiles = false,
					custom = { ".DS_Store", "node_modules", "dist" },
				},
				git = { enable = true, ignore = false },
				renderer = {
					highlight_git = true,
					indent_markers = { enable = true },
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		config = function()
			require("flash").setup({
				labels = "asdfghjklqwertyuiopzxcvbnm",
				search = {
					multi_window = true,
					forward = true,
					wrap = true,
					case_sensitive = false,
				},
				jump = { autojump = true },
				modes = { char = { enabled = true, highlight = { backdrop = true } } },
			})
		end,
	},

	-- Code analysis, highlighting, and formatting
	{ "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
	{ "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" } },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
					"lua",
					"python",
					"go",
					"rust",
					"toml",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				scope = { enabled = true, show_start = true },
			})
		end,
	},

	-- Git integration
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{ "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"akinsho/git-conflict.nvim",
		config = function()
			require("git-conflict").setup()
		end,
	},

	-- Debugging
	{ "mfussenegger/nvim-dap" },
	{ "mfussenegger/nvim-dap-python" },
	{ "nvim-neotest/nvim-nio" },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- Code navigation
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup()
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup()
		end,
	},

	-- Language-specific plugins
	{
		"saecki/crates.nvim",
		tag = "stable",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = { "rust", "toml" },
		config = function()
			require("crates").setup({
				completion = { cmp = { enabled = true } },
			})
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup({
				lsp_cfg = false,
				lsp_gofumpt = true,
				lsp_on_attach = true,
				dap_debug = true,
				dap_debug_vt = true,
				dap_debug_gui = true,
			})
		end,
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	-- UI/UX improvemnets
	{
		"mg979/vim-visual-multi",
		config = function()
			vim.g.VM_theme = "ocean"
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup()
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = function()
			require("noice").setup({
				notify = { enabled = false },
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
				routes = { { view = "notify", filter = { event = "msg_showmode" } } },
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup()
		end,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "treesitter", "regex" },
				delay = 100,
				filetypes_denylist = { "dirvish", "fugitive", "NvimTree" },
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true,
				stop_eof = true,
				respect_scrolloff = true,
				cursor_scrolls_alone = true,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"dstein64/nvim-scrollview",
		config = function()
			require("scrollview").setup({
				excluded_filetypes = { "NvimTree", "toggleterm", "help" },
				current_only = true,
				base = "right",
				column = 1,
				signs_on_startup = { "diagnostics", "search", "marks" },
				diagnostics_severities = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},
			})
		end,
	},

	-- Utilities
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				direction = "float",
				float_opts = { border = "curved", width = 100, height = 20, winblend = 3 },
				shade_terminals = true,
			})
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = { "nvim-telescope/telescope.nvim", { "kkharji/sqlite.lua", module = "sqlite" } },
		config = function()
			require("neoclip").setup({
				history = 1000,
				enable_persistent_history = false,
				length_limit = 1048576,
				continuous_sync = false,
				db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
				preview = true,
				default_register = '"',
				default_register_macros = "q",
				enable_macro_history = true,
			})
		end,
	},
	{
		"AckslD/swenv.nvim",
		config = function()
			require("swenv").setup({
				get_venvs = function()
					local project_root = vim.fn.getcwd()
					local project_venv = project_root .. "/.venv"
					if vim.fn.isdirectory(project_venv) == 1 then
						return { [".venv (Project)"] = project_venv }
					else
						return require("swenv.api").get_venvs_stable_order()
					end
				end,
				post_set_venv = function()
					vim.cmd("LspRestart")
				end,
			})
		end,
	},
	{ "mattn/emmet-vim" },
	{ "cdelledonne/vim-cmake" },
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				ts_config = { lua = { "string" }, javascript = { "template_string" }, java = false },
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({
				signs = true,
				keywords = {
					FIX = { icon = "", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
					TODO = { icon = "", color = "info" },
					HACK = { icon = "", color = "warning" },
					WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = "", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = "", color = "hint", alt = { "INFO" } },
				},
			})
		end,
	},
})

-- =============================================================================
-- LSP Configuration
-- =============================================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()


local function on_attach(client, bufnr)
	-- navic connection
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end

	-- Basic key mappings
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
end

-- TypeScript
require("lspconfig").ts_ls.setup({
	capabilities = capabilities,
	root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json"),
	handlers = {
		["textDocument/publishDiagnostics"] = function(_, params, _, config)
			if params and params.diagnostics then
				for _, diagnostic in ipairs(params.diagnostics) do
					if diagnostic.relatedInformation and diagnostic.relatedInformation[1] then
						diagnostic.message =
							string.format("%s\n%s", diagnostic.message, diagnostic.relatedInformation[1].message)
					end
					if diagnostic.range then
						local filename = vim.fn.fnamemodify(params.uri, ":t")
						if filename then
							local line = diagnostic.range.start.line + 1
							local col = diagnostic.range.start.character + 1
							diagnostic.message =
								string.format("%s(%d, %d): %s", filename, line, col, diagnostic.message)
						end
					end
				end
			end
			vim.lsp.diagnostic.on_publish_diagnostics(_, params, _, config)
		end,
	},
	on_attach = on_attach,
})

-- TailwindCSS
require("lspconfig").tailwindcss.setup({
	capabilities = capabilities,
	root_dir = require("lspconfig").util.root_pattern(
		"tailwind.config.js",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.ts"
	),
	settings = {
		tailwindCSS = {
			classAttributes = { "cn", "class", "className", ".*ClassName" }, -- matches VS Code
			experimental = {
				classRegex = {
					-- Matches VS Code patterns exactly
					"className:\\s*['\"`]([^'\"`]*)['\"`]",
					"cn\\(([^)]*)\\)",
					"[\"'`]([^\"'`]*).*?[\"'`]",
				},
			},
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
		},
	},
	on_attach = on_attach,
})

-- ESLint LSP disabled - using eslint_d via nvim-lint instead
-- This avoids "Unable to find ESLint library" errors

-- Python
require("lspconfig").pyright.setup({
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				ignore = { "layer/python/*" },
			},
		},
	},
	on_attach = on_attach,
})

-- Go
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
			gofumpt = true,
			usePlaceholders = true,
			completeUnimported = true,
			matcher = "fuzzy",
		},
	},
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		-- Go-specific keymaps
		vim.keymap.set(
			"n",
			"<leader>gtf",
			"<cmd>lua vim.lsp.buf.type_definition()<CR>",
			{ buffer = bufnr, desc = "Go to type definition" }
		)
		vim.keymap.set(
			"n",
			"<leader>gim",
			"<cmd>lua vim.lsp.buf.implementation()<CR>",
			{ buffer = bufnr, desc = "Go to implementation" }
		)
	end,
})

-- Rust
require("lspconfig").rust_analyzer.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		-- Enable inlay hints by default for rust-analyzer
		if client.name == "rust_analyzer" and vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Rust-specific keymaps
		vim.keymap.set("n", "<leader>rh", function()
			-- Force toggle - if not visible, enable them with error handling
			local ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
			if not ok then
				vim.notify("Inlay hints not available", vim.log.levels.WARN)
				return
			end
			if enabled then
				pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
				vim.notify("Inlay hints disabled")
			else
				pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
				vim.notify("Inlay hints enabled")
			end
		end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
		vim.keymap.set("n", "<leader>rr", ":LspRestart<CR>", { buffer = bufnr, desc = "LSP Restart" })
		vim.keymap.set(
			"n",
			"<leader>rt",
			"<cmd>lua vim.lsp.buf.code_action()<CR>",
			{ buffer = bufnr, desc = "Rust test" }
		)
		vim.keymap.set(
			"n",
			"<leader>rd",
			"<cmd>lua vim.lsp.buf.code_action()<CR>",
			{ buffer = bufnr, desc = "Rust debug" }
		)
	end,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = { command = "check" }, -- Use 'check' instead of 'clippy' to avoid conflicts
			inlayHints = {
				bindingModeHints = { enable = false },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				closureReturnTypeHints = { enable = "never" },
				lifetimeElisionHints = { enable = "never", useParameterNames = false },
				maxLength = 25,
				parameterHints = { enable = true },
				reborrowHints = { enable = "never" },
				renderColons = true,
				typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
			},
			diagnostics = { enable = true, experimental = { enable = true } },
			completion = { addCallArgumentSnippets = true, addCallParenthesis = true },
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				runBuildScripts = true,
				autoreload = true,
			},
			procMacro = { enable = true },
			files = {
				watcherExclude = {
					"**/target/**",
					"**/.git/**",
				},
			},
		},
	},
})

-- =============================================================================
-- Auto-completion Configuration (nvim-cmp)
-- =============================================================================
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = { { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" } },
})

-- =============================================================================
-- Debugger Configuration (nvim-dap)
-- =============================================================================
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

-- =============================================================================
-- Linter and Formatter Configuration (nvim-lint & conform.nvim)
-- =============================================================================
-- Linting
require("lint").linters_by_ft = {
	javascript = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascriptreact = { "eslint" },
	python = { "ruff" },
	go = { "golangcilint" },
	rust = { "clippy" },
}

-- ESLint conditional configuration
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
	callback = function()
		local project = detect_project_type()

		if not (project.is_frontend or project.is_backend or project.is_cdk) then
			require("lint").linters_by_ft["javascript"] = {}
			require("lint").linters_by_ft["typescript"] = {}
			require("lint").linters_by_ft["typescriptreact"] = {}
			require("lint").linters_by_ft["javascriptreact"] = {}
		end
	end,
})

-- Custom golangci-lint configuration
require("lint").linters.golangcilint = {
	cmd = "golangci-lint",
	stdin = false,
	args = { "run", "--out-format", "json", "--issues-exit-code=0" },
	stream = "stdout",
	ignore_exitcode = true,
	parser = function(output, bufnr)
		local diagnostics = {}
		if output == "" then
			return diagnostics
		end

		local decoded = vim.json.decode(output)
		if not decoded or not decoded.Issues then
			return diagnostics
		end

		for _, issue in ipairs(decoded.Issues) do
			local filename = issue.Pos.Filename
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if vim.fn.fnamemodify(filename, ":p") == bufname then
				table.insert(diagnostics, {
					lnum = issue.Pos.Line - 1,
					col = issue.Pos.Column - 1,
					end_lnum = issue.Pos.Line - 1,
					end_col = issue.Pos.Column - 1,
					severity = 1,
					message = issue.Text,
					source = issue.FromLinter,
				})
			end
		end
		return diagnostics
	end,
}

-- ESLint auto-fix on save using eslint_d (matches VS Code "source.fixAll.eslint": "explicit")
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = function()
		local project = detect_project_type()

		if not project.has_eslint then
			return -- No ESLint config, skip auto-fix
		end

		-- Use eslint_d directly for auto-fix
		local filename = vim.fn.expand("%:p")
		if filename and filename ~= "" then
			vim.fn.jobstart({
				"eslint_d",
				"--fix",
				filename,
			}, {
				on_exit = function(_, exit_code)
					-- Only reload if eslint_d made changes
					vim.schedule(function()
						-- Use edit! for faster reload
						vim.cmd("silent! edit!")
					end)
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
		vim.diagnostic.show()
	end,
})

-- Formatting
require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		python = { "black", "isort" },
		lua = { "stylua" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
	},
	format_on_save = { timeout_ms = 3000, lsp_fallback = true },
	formatters = {
		prettier = {
			env = { PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/prettierrc.json") },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				local project = detect_project_type(root_dir)

				-- Always allow markdown formatting (ignore condition)
				local filetype = vim.bo.filetype
				if filetype == "markdown" then
					return true
				end

				return project.has_prettier or project.is_cdk
			end,
			prepend_args = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				local project = detect_project_type(root_dir)

				if project.is_frontend then
					return { "--plugin", "prettier-plugin-tailwindcss" }
				end
				return {}
			end,
		},
		black = {
			prepend_args = { "--line-length", "88", "--preview", "--enable-unstable-feature", "string_processing" },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				local project = detect_project_type(root_dir)
				return project.has_python
			end,
		},
		isort = {
			prepend_args = { "--profile", "black" },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				local project = detect_project_type(root_dir)
				return project.has_python
			end,
		},
	},
})

-- =============================================================================
-- Autocmds
-- =============================================================================
-- Language-specific file format settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	command = "setlocal tabstop=4 shiftwidth=4 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	command = "setlocal tabstop=4 shiftwidth=4 noexpandtab",
})

-- Rust configuration (integrated)
local rust_augroup = vim.api.nvim_create_augroup("RustConfig", { clear = true })

-- Auto-restart rust-analyzer when Cargo.toml changes
vim.api.nvim_create_autocmd("BufWritePost", {
	group = rust_augroup,
	pattern = "Cargo.toml",
	callback = function()
		vim.defer_fn(function()
			vim.cmd("LspRestart rust_analyzer")
			vim.notify("rust-analyzer restarted due to Cargo.toml changes")
		end, 500)
	end,
})
-- Commented out: conflicts with conform.nvim formatting
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = rust_augroup,
-- 	pattern = "*.rs",
-- 	callback = function()
-- 		vim.lsp.buf.format({ async = false })
-- 	end,
-- })
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
			vim.cmd("TSBufDisable highlight")
			vim.notify("Large Rust file detected, disabling TreeSitter highlights for performance")
		end
		vim.lsp.set_log_level("WARN")
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

-- Go configuration (integrated)
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
		if file_size > 1024 * 1024 then -- Over 1MB
			vim.cmd("syntax off")
			vim.cmd("TSBufDisable highlight")
			vim.notify("Large file detected, disabling syntax for performance")
		end
	end,
})

-- Config file optimization
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = vim.fn.stdpath("config") .. "/init.lua",
	callback = function()
		vim.cmd("LspStop")
		vim.cmd("TSBufDisable highlight")
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
				-- Simple regex to extract cSpell.words array
				local words_match = json_str:match('"cSpell%.words"%s*:%s*%[([^%]]+)%]')
				if words_match then
					local custom_words = {}
					for word in words_match:gmatch('"([^"]+)"') do
						table.insert(custom_words, word)
					end

					if #custom_words > 0 then
						-- Create project-specific spell file
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

							-- Set project-specific spellfile for current buffer
							vim.opt_local.spellfile = spell_file
						end
					end
				end
			end
		end
	end,
})

-- Pre-initialize formatters
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			-- Initialize formatters asynchronously
			vim.fn.jobstart("black --version", { detach = true, stderr_buffered = true, stdout_buffered = true })
			vim.fn.jobstart("isort --version", { detach = true, stderr_buffered = true, stdout_buffered = true })
			vim.fn.jobstart("prettier --version", { detach = true, stderr_buffered = true, stdout_buffered = true })
			vim.fn.jobstart("eslint --version", { detach = true, stderr_buffered = true, stdout_buffered = true })
			vim.fn.jobstart("ruff --version", { detach = true, stderr_buffered = true, stdout_buffered = true })
			vim.notify("Formatters initialized", vim.log.levels.INFO)
		end, 1000)
	end,
	once = true,
})

-- =============================================================================
-- User-defined Commands
-- =============================================================================
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

-- =============================================================================
-- Key Mappings (Keymaps)
-- =============================================================================
-- File exploration
local tree = require("nvim-tree.api")
vim.keymap.set("n", "<leader>ft", tree.tree.toggle, { desc = "Toggle File Explorer" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text (live grep)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
vim.keymap.set("n", "<leader>fc", builtin.lsp_document_symbols, { desc = "Search document symbols" })
vim.keymap.set("n", "<leader>fC", builtin.lsp_workspace_symbols, { desc = "Search workspace symbols" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search current word" })
vim.keymap.set("n", "<leader>fn", ":Telescope neoclip<CR>", { desc = "Show clipboard history" })
vim.keymap.set("n", "<leader>fT", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })

-- Load Telescope extensions
require("telescope").load_extension("neoclip")

-- Rust project-related search
vim.keymap.set("n", "<leader>rc", function()
	builtin.find_files({
		prompt_title = "Find Cargo.toml",
		search_file = "Cargo.toml",
		cwd = vim.fn.getcwd(),
	})
end, { desc = "Find Cargo.toml" })
vim.keymap.set("n", "<leader>rs", function()
	builtin.live_grep({
		prompt_title = "Search in Rust files",
		type_filter = "rust",
	})
end, { desc = "Search in Rust files" })

-- Harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<leader>hm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Menu" })
vim.keymap.set("n", "<leader>h1", function()
	harpoon:list():select(1)
end, { desc = "Go to Harpoon file 1" })
vim.keymap.set("n", "<leader>h2", function()
	harpoon:list():select(2)
end, { desc = "Go to Harpoon file 2" })
vim.keymap.set("n", "<leader>h3", function()
	harpoon:list():select(3)
end, { desc = "Go to Harpoon file 3" })
vim.keymap.set("n", "<leader>h4", function()
	harpoon:list():select(4)
end, { desc = "Go to Harpoon file 4" })
vim.keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Previous Harpoon file" })
vim.keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Next Harpoon file" })

-- Harpoon extension configuration
harpoon:extend({
	UI_CREATE = function(cx)
		vim.keymap.set("n", "<C-v>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<C-x>", function()
			harpoon.ui:select_menu_item({ split = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<C-t>", function()
			harpoon.ui:select_menu_item({ tabedit = true })
		end, { buffer = cx.bufnr })
	end,
})

-- Cargo commands
local Terminal = require("toggleterm.terminal").Terminal
local function run_cargo_cmd(cmd, opts)
	opts = opts or {}
	local term = Terminal:new({
		cmd = cmd,
		direction = opts.direction or "float",
		close_on_exit = opts.close_on_exit or false,
		auto_scroll = true,
	})
	term:toggle()
end

vim.keymap.set("n", "<leader>cr", function()
	run_cargo_cmd("cargo run")
end, { desc = "Cargo Run" })
vim.keymap.set("n", "<leader>ct", function()
	run_cargo_cmd("cargo test")
end, { desc = "Cargo Test" })
vim.keymap.set("n", "<leader>cc", function()
	run_cargo_cmd("cargo check")
end, { desc = "Cargo Check" })
vim.keymap.set("n", "<leader>cb", function()
	run_cargo_cmd("cargo build")
end, { desc = "Cargo Build" })
vim.keymap.set("n", "<leader>cC", function()
	run_cargo_cmd("cargo clippy")
end, { desc = "Cargo Clippy" })
vim.keymap.set("n", "<leader>cw", function()
	run_cargo_cmd("cargo watch -x check")
end, { desc = "Cargo Watch" })
vim.keymap.set("n", "<leader>cf", function()
	run_cargo_cmd("cargo fmt")
end, { desc = "Cargo Format" })
vim.keymap.set("n", "<leader>cd", function()
	run_cargo_cmd("cargo doc --open")
end, { desc = "Cargo Doc" })

-- Interactive Cargo commands
vim.keymap.set("n", "<leader>cR", function()
	local args = vim.fn.input("cargo run arguments: ")
	local cmd = args ~= "" and "cargo run " .. args or "cargo run"
	run_cargo_cmd(cmd)
end, { desc = "Cargo Run with args" })
vim.keymap.set("n", "<leader>cT", function()
	local test_name = vim.fn.input("Test name (optional): ")
	local cmd = test_name ~= "" and "cargo test " .. test_name or "cargo test"
	run_cargo_cmd(cmd)
end, { desc = "Cargo Test specific" })

-- Terminal direction-specific execution
vim.keymap.set("n", "<leader>crh", function()
	run_cargo_cmd("cargo run", { direction = "horizontal" })
end, { desc = "Cargo Run (horizontal)" })
vim.keymap.set("n", "<leader>crv", function()
	run_cargo_cmd("cargo run", { direction = "vertical" })
end, { desc = "Cargo Run (vertical)" })

-- Bufferline
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
vim.keymap.set("n", "<leader>bx", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Close all buffers to the left" })
vim.keymap.set("n", "<leader>bX", "<Cmd>BufferLineCloseRight<CR>", { desc = "Close all buffers to the right" })
vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Close all other buffers" })
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>bs", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort buffers by directory" })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic List" })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- Flash
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end)
vim.keymap.set({ "n", "x", "o" }, "<leader>fs", function()
	require("flash").treesitter()
end, { desc = "Search Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end)
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end)

-- hlslens
local kopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
	"n",
	"n",
	[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
	kopts
)
vim.api.nvim_set_keymap(
	"n",
	"N",
	[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
	kopts
)
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- Clear search highlights
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>noh<CR>", kopts)

-- Noice
vim.keymap.set("n", "<leader>nl", function()
	require("noice").cmd("last")
end, { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>nh", function()
	require("noice").cmd("history")
end, { desc = "Noice History" })
vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-f>"
	end
end, { silent = true, expr = true })
vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-b>"
	end
end, { silent = true, expr = true })

-- Miscellaneous
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Aerial Toggle" })
vim.keymap.set("n", "<leader>sv", function()
	require("swenv.api").pick_venv()
end, { desc = "Select virtual environment" })

-- which-key registration (new spec format)
require("which-key").add({
	-- Group definitions
	{ "<leader>r", group = "Rust" },
	{ "<leader>rr", desc = "LSP Restart" },
	{ "<leader>rh", desc = "Toggle Inlay Hints" },
	{ "<leader>rt", desc = "Rust test" },
	{ "<leader>rd", desc = "Rust debug" },
	{ "<leader>rc", desc = "Find Cargo.toml" },
	{ "<leader>rs", desc = "Search in Rust files" },
	{ "<leader>c", group = "Cargo" },
	{ "<leader>h", group = "Harpoon" },
	{ "<leader>f", group = "Find" },
	{ "<leader>b", group = "Buffer" },
	{ "<leader>x", group = "Trouble" },
	{ "<leader>g", group = "Go" },
	{ "<leader>n", group = "Noice" },
})

-- =============================================================================
-- UI and Other Settings
-- =============================================================================
-- Winbar
vim.api.nvim_set_hl(0, "Winbar", { bg = "#1a1b26", fg = "#a9b1d6", bold = true, italic = false })
vim.api.nvim_set_hl(0, "NavicText", { fg = "#a9b1d6", bg = "#1a1b26" })
vim.api.nvim_set_hl(0, "NavicSeparator", { fg = "#565f89", bg = "#1a1b26" })
vim.o.winbar = "%#Winbar#%{%v:lua.require'nvim-navic'.get_location()%}"

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
