-- ~/.config/nvim/init.lua

-- Lazy.nvim 설치
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

-- 기본 설정
vim.g.mapleader = " "
vim.o.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true

-- Lazy.nvim으로 플러그인 설정
require("lazy").setup({
	-- 테마 및 UI
	{
		"folke/tokyonight.nvim",
		lazy = false, -- 즉시 로드
		priority = 1000, -- 테마는 먼저 로드되도록
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
	{ "kyazdani42/nvim-web-devicons" },
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
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("nvim-navic").setup({
				icons = {
					File = "󰈙 ",
					Module = " ",
					Namespace = "󰌗 ",
					Package = " ",
					Class = "󰌗 ",
					Method = "󰆧 ",
					Property = " ",
					Field = " ",
					Constructor = " ",
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
					EnumMember = " ",
					Struct = "󰌗 ",
					Event = " ",
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

	-- LSP 및 자동완성
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "tailwindcss", "pyright", "gopls" },
			})
		end,
	},

	-- Mason tools auto installation
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Python tools
					"black", -- formatter
					"isort", -- import formatter
					"ruff", -- linter

					-- TypeScript / JavaScript tools
					"prettier",
					"eslint_d",

					-- Go tools
					"gopls", -- Go language server
					"golangci-lint", -- Go linter
					"gofumpt", -- Go formatter (gofmt strict version)
					"goimports", -- import auto management

					-- other tools
					"stylua", -- Lua formatter
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },

	-- 파일 탐색 및 검색
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
		end,
	},

	-- Git 통합
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- 코드 분석 및 하이라이팅
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "typescript", "javascript", "tsx", "html", "css", "lua", "python", "go" },
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

	-- null-ls 대신 사용할 두 플러그인 추가
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- Git 관련 추가 플러그인
	{ "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"akinsho/git-conflict.nvim",
		config = function()
			require("git-conflict").setup()
		end,
	},

	-- 디버깅
	{ "mfussenegger/nvim-dap" },
	{ "mfussenegger/nvim-dap-python" },
	{ "nvim-neotest/nvim-nio" },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
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

	-- 코드 네비게이션
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "Add file to Harpoon" })
			vim.keymap.set("n", "<leader>hm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle Harpoon menu" })
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
		end,
	},

	-- 새로 추가된 플러그인들
	{
		"mg979/vim-visual-multi",
		config = function()
			vim.g.VM_theme = "ocean"
			vim.g.VM_highlight_matches = "underline"
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
			vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
			vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
			vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
			vim.keymap.set(
				"n",
				"<leader>bx",
				"<Cmd>BufferLineCloseLeft<CR>",
				{ desc = "Close all buffers to the left" }
			)
			vim.keymap.set(
				"n",
				"<leader>bX",
				"<Cmd>BufferLineCloseRight<CR>",
				{ desc = "Close all buffers to the right" }
			)
			vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Close all other buffers" })
			vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
			vim.keymap.set(
				"n",
				"<leader>bs",
				"<Cmd>BufferLineSortByDirectory<CR>",
				{ desc = "Sort buffers by directory" }
			)
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
			require("illuminate").configure()
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	},
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
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
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
			require("telescope").load_extension("neoclip")
			vim.keymap.set(
				"n",
				"<leader>fn",
				":Telescope neoclip<CR>",
				{ noremap = true, desc = "복사 히스토리 보기" }
			)
		end,
	},
	{
		"AckslD/swenv.nvim",
		config = function()
			require("swenv").setup({
				-- 프로젝트 루트의 .venv 디렉토리를 자동으로 감지
				get_venvs = function()
					local project_root = vim.fn.getcwd()
					local project_venv = project_root .. "/.venv"

					if vim.fn.isdirectory(project_venv) == 1 then
						return { [".venv (Project)"] = project_venv }
					else
						-- 프로젝트 venv가 없으면 중앙 venvs 디렉토리 확인
						return require("swenv.api").get_venvs_stable_order()
					end
				end,
				post_set_venv = function()
					vim.cmd("LspRestart")
				end,
			})
			vim.keymap.set("n", "<leader>sv", function()
				require("swenv.api").pick_venv()
			end, { desc = "Select virtual environment" })
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
				lsp_cfg = false, -- gopls 설정은 lspconfig에서 이미 했으므로 비활성화
				lsp_gofumpt = true, -- gofumpt를 사용하여 포맷팅
				lsp_on_attach = true, -- 기본 on_attach 사용
				dap_debug = true, -- DAP 디버깅 활성화
				dap_debug_vt = true, -- 가상 텍스트로 변수 값 표시
				dap_debug_gui = true, -- GUI 디버깅 활성화
			})

			-- gopls 시작을 위한 자동 명령
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").goimport()
				end,
				group = format_sync_grp,
			})
		end,
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	-- 기타 유틸리티
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
			vim.keymap.set(
				"n",
				"<leader>fT",
				"<cmd>TodoTelescope<cr>",
				{ noremap = true, silent = true, desc = "Search TODOs" }
			)
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
})

-- LSP 설정 (Packer 외부 설정 유지)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	end,
})

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
			classAttributes = { "cn", "class", "className", "classList", "ngClass", "wrapperClassName" },
			experimental = {
				classRegex = {
					"className[\\s]*=[\\s]*[\\{][\\s]*[\"'`]([^\"'`]*)[\"'`][\\s]*[\\}]",
					"cn\\(['\"](.*?)['\"]\\)",
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
})

-- Python LSP 설정
require("lspconfig").pyright.setup({
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				ignore = {
					"layer/python/*",
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	end,
})

-- Go LSP 설정
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			gofumpt = true,
			usePlaceholders = true,
			completeUnimported = true,
			matcher = "fuzzy",
		},
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end

		-- 기본 키 매핑
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })

		-- Go 전용 키 매핑
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

-- 자동 완성 설정
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- Python 디버깅 설정
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

-- Nvim-tree 키 매핑
local tree = require("nvim-tree.api")
vim.keymap.set("n", "<leader>ft", tree.tree.toggle, { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Telescope 키 매핑
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text (live grep)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
vim.keymap.set("n", "<leader>fc", builtin.lsp_document_symbols, { desc = "Search document symbols" })
vim.keymap.set("n", "<leader>fC", builtin.lsp_workspace_symbols, { desc = "Search workspace symbols" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search current word" })
vim.keymap.set("n", "<leader>fn", ":Telescope neoclip<CR>", { noremap = true, desc = "Show clipboard history" })

-- null-ls 대신 nvim-lint 및 conform.nvim 설정
-- 1. 린팅 설정 (nvim-lint)
require("lint").linters_by_ft = {
	javascript = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascriptreact = { "eslint" },
	python = { "ruff" },
	go = { "golangcilint" },
}

-- 파일 저장 시 린팅 실행
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
		vim.diagnostic.show()
	end,
})

-- ESLint 관련 조건부 설정
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
	callback = function()
		local root = vim.fn.getcwd()
		local is_frontend = vim.fn.filereadable(root .. "/package.json") == 1
			or vim.fn.filereadable(root .. "/tsconfig.json") == 1
			or vim.fn.filereadable(root .. "/tailwind.config.js") == 1
			or vim.fn.filereadable(root .. "/tailwind.config.ts") == 1
		local is_backend = vim.fn.filereadable(root .. "/nest-cli.json") == 1
			or vim.fn.filereadable(root .. "/tsconfig.build.json") == 1
		local is_cdk = vim.fn.filereadable(root .. "/cdk.json") == 1

		if not (is_frontend or is_backend or is_cdk) then
			require("lint").linters_by_ft["javascript"] = {}
			require("lint").linters_by_ft["typescript"] = {}
			require("lint").linters_by_ft["typescriptreact"] = {}
			require("lint").linters_by_ft["javascriptreact"] = {}
		end
	end,
})

-- 2. 포맷팅 설정 (conform.nvim)
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
	},
	format_on_save = {
		timeout_ms = 3000,
		lsp_fallback = true,
	},
	formatters = {
		prettier = {
			env = {
				PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/prettierrc.json"),
			},
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""

				local has_prettier = vim.fn.filereadable(root_dir .. "/.prettierrc") == 1
					or vim.fn.filereadable(root_dir .. "/.prettierrc.json") == 1
					or vim.fn.filereadable(root_dir .. "/.prettierrc.js") == 1
					or vim.fn.filereadable(root_dir .. "/.prettierrc.yml") == 1
					or vim.fn.filereadable(root_dir .. "/prettier.config.js") == 1
				local is_cdk = vim.fn.filereadable(root_dir .. "/cdk.json") == 1
				return has_prettier or is_cdk
			end,
			prepend_args = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""

				local is_frontend = vim.fn.filereadable(root_dir .. "/tailwind.config.js") == 1
					or vim.fn.filereadable(root_dir .. "/tailwind.config.ts") == 1
				if is_frontend then
					return { "--plugin", "prettier-plugin-tailwindcss" }
				end
				return {}
			end,
		},
		black = {
			prepend_args = { "--line-length", "88", "--preview", "--enable-unstable-feature", "string_processing" },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				-- has_file_in_project 함수를 직접 호출하지 않고 내부 로직 사용
				for _, file in ipairs({
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					".python-version",
				}) do
					local found = vim.fn.glob(root_dir .. "/**/" .. file, true)
					if found ~= "" then
						return true
					end
				end
				return false
			end,
		},
		isort = {
			prepend_args = { "--profile", "black" },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				-- has_file_in_project 함수를 직접 호출하지 않고 내부 로직 사용
				for _, file in ipairs({
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					".python-version",
				}) do
					local found = vim.fn.glob(root_dir .. "/**/" .. file, true)
					if found ~= "" then
						return true
					end
				end
				return false
			end,
		},
	},
})

-- 진단 표시 설정
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

-- 탭 설정
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false
vim.cmd([[autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab]])
vim.cmd([[autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab]])

-- Winbar 설정
vim.api.nvim_set_hl(0, "Winbar", { bg = "#1a1b26", fg = "#a9b1d6", bold = true, italic = false })
vim.api.nvim_set_hl(0, "NavicText", { fg = "#a9b1d6", bg = "#1a1b26" })
vim.api.nvim_set_hl(0, "NavicSeparator", { fg = "#565f89", bg = "#1a1b26" })
vim.o.winbar = "%#Winbar#%{%v:lua.require'nvim-navic'.get_location()%}"

-- 에러 탐색 키맵
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to the previous error" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to the next error" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "See error details" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "See error list" })

-- hlslens 키 매핑
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

-- Trouble 키매핑
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- 검색 하이라이트 지우기
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>noh<CR>", kopts)

-- neoscroll 설정
require("neoscroll").setup({
	mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
	hide_cursor = true,
	stop_eof = true,
	respect_scrolloff = true,
	cursor_scrolls_alone = true,
})

-- illuminate 설정
require("illuminate").configure({
	providers = { "lsp", "treesitter", "regex" },
	delay = 100,
	filetypes_denylist = { "dirvish", "fugitive", "NvimTree" },
})

-- markdown preview 설정
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_browser = ""
vim.g.mkdp_echo_preview_url = 0
vim.g.mkdp_page_title = "${name}"

-- init.lua 파일 편집 시 성능 최적화
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = vim.fn.stdpath("config") .. "/init.lua",
	callback = function()
		vim.cmd("LspStop")
		vim.cmd("TSBufDisable highlight")
		vim.notify("Config file opened with limited features to prevent freezing")
	end,
})

-- LSP 진단 표시 기능 설정
if vim.diagnostic and vim.diagnostic.config then
	vim.diagnostic.config({
		virtual_text = { prefix = "●", source = "always", spacing = 4 },
		float = { source = "always", border = "rounded", header = "", prefix = "" },
		signs = true,
		underline = true,
		severity_sort = true,
	})
end

-- Python 관련 파일 형식 인식을 위한 설정
vim.filetype.add({
	extension = {
		py = "python",
	},
})

-- 저장 시 자동 포맷팅을 위한 명시적 autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Neovim 시작 완료 후 비동기적으로 포맷터 초기화
		vim.defer_fn(function()
			-- Python 포맷터
			vim.fn.jobstart("black --version", {
				detach = true,
				stderr_buffered = true,
				stdout_buffered = true,
			})

			vim.fn.jobstart("isort --version", {
				detach = true,
				stderr_buffered = true,
				stdout_buffered = true,
			})

			-- JavaScript/TypeScript 포맷터
			vim.fn.jobstart("prettier --version", {
				detach = true,
				stderr_buffered = true,
				stdout_buffered = true,
			})

			-- 린터도 미리 초기화
			vim.fn.jobstart("eslint --version", {
				detach = true,
				stderr_buffered = true,
				stdout_buffered = true,
			})

			vim.fn.jobstart("ruff --version", {
				detach = true,
				stderr_buffered = true,
				stdout_buffered = true,
			})

			vim.notify("Formatter initialized", vim.log.levels.INFO)
		end, 1000) -- 1초 후 실행
	end,
	once = true, -- 한 번만 실행
})
