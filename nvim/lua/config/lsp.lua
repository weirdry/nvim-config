-- Global capabilities for all LSP servers
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Centralized LspAttach handler
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })

		if client.name == "gopls" then
			vim.keymap.set("n", "<leader>gtf", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
			vim.keymap.set("n", "<leader>gim", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
		end
	end,
})

-- TypeScript
vim.lsp.config("ts_ls", {
	root_markers = { "package.json", "tsconfig.json" },
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
})

-- TailwindCSS
vim.lsp.config("tailwindcss", {
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.ts",
	},
	settings = {
		tailwindCSS = {
			classAttributes = { "cn", "class", "className", ".*ClassName" },
			experimental = {
				classRegex = {
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
})

-- ESLint LSP disabled - using eslint_d via nvim-lint instead

-- Python
vim.lsp.config("pyright", {
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
})

-- Go
vim.lsp.config("gopls", {
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
})

-- Rust LSP is handled by rustaceanvim plugin (not configured here)

-- Protocol Buffers
vim.lsp.config("buf_ls", {})

-- Terraform
vim.lsp.config("terraformls", {
	filetypes = { "terraform", "hcl" },
	settings = {
		terraformls = {
			validation = { enabled = true },
		},
	},
})

-- Enable all LSP servers
vim.lsp.enable({
	"ts_ls",
	"tailwindcss",
	"pyright",
	"gopls",
	"buf_ls",
	"terraformls",
})
