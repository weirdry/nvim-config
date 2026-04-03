return {
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
		"Bekaboo/dropbar.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dropbar").setup({
				bar = {
					sources = function(buf, _)
						local sources = require("dropbar.sources")
						local utils = require("dropbar.utils")
						if vim.bo[buf].ft == "markdown" then
							return { sources.path, sources.markdown }
						end
						if vim.bo[buf].buftype == "terminal" then
							return { sources.terminal }
						end
						return { sources.path, utils.source.fallback({ sources.lsp, sources.treesitter }) }
					end,
				},
			})
		end,
	},
	{ "nvim-tree/nvim-web-devicons" },

	-- LSP, auto-completion, and tool installation
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"ruff",
					"prettier",
					"eslint_d",
					"gopls",
					"golangci-lint",
					"gofumpt",
					"goimports",
					"codelldb",
					"buf",
					"terraform-ls",
					"tflint",
					"tfsec",
					"stylua",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "none",
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = true } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},

	-- File exploration and search
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			filters = { dotfiles = false, custom = { ".DS_Store", "node_modules", "dist" } },
			git = { enable = true, ignore = false },
			renderer = { highlight_git = true, indent_markers = { enable = true } },
		},
	},
	{
		"folke/flash.nvim",
		opts = {
			labels = "asdfghjklqwertyuiopzxcvbnm",
			search = { multi_window = true, forward = true, wrap = true, case_sensitive = false },
			jump = { autojump = true },
			modes = { char = { enabled = true, highlight = { backdrop = true } } },
		},
	},

	-- Code analysis, highlighting, and formatting
	{ "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
	{ "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" } },
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"typescript", "javascript", "tsx", "html", "css", "lua",
					"python", "go", "rust", "toml", "proto", "hcl",
					"markdown", "markdown_inline",
				},
			})
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = true, show_start = true } } },

	-- Git integration
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "akinsho/git-conflict.nvim", opts = {} },

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
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
		end,
	},

	-- Code navigation
	{ "stevearc/aerial.nvim", opts = {} },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function() require("harpoon"):setup() end,
	},

	-- Language-specific plugins
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = { tools = { test_executor = "background" } }
		end,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = { "rust", "toml" },
		opts = {},
	},
	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
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

	-- UI/UX
	{ "mg979/vim-visual-multi", init = function() vim.g.VM_theme = "ocean" end },
	{ "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = function()
			require("noice").setup({
				notify = { enabled = false },
				lsp = { progress = { enabled = false } },
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
	{ "j-hui/fidget.nvim", opts = {} },
	{ "kylechui/nvim-surround", opts = {} },
	{ "kevinhwang91/nvim-hlslens", opts = {} },
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
		opts = {
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = true,
			cursor_scrolls_alone = true,
		},
	},
	{ "folke/which-key.nvim", opts = {} },
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
		build = function() vim.fn["mkdp#util#install"]() end,
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
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
			ts_config = { lua = { "string" }, javascript = { "template_string" }, java = false },
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				options = {
					parsers = {
						names = { enable = false },
						hex = { default = true, rrggbbaa = true },
						rgb = { enable = true },
						hsl = { enable = true },
						css = true,
						css_fn = true,
					},
					display = { mode = "background" },
				},
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
}
