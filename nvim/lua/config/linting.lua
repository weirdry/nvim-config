local helpers = require("config.helpers")

-- Linting
require("lint").linters_by_ft = {
	javascript = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascriptreact = { "eslint" },
	python = { "ruff" },
	go = { "golangcilint" },
	terraform = { "tflint", "tfsec" },
}

-- ESLint conditional configuration
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
	callback = function()
		local project = helpers.detect_project_type()
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

-- ESLint auto-fix on save using eslint_d
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = function()
		local project = helpers.detect_project_type()
		if not project.has_eslint then
			return
		end

		local filename = vim.fn.expand("%:p")
		if filename and filename ~= "" then
			local mtime_before = vim.uv.fs_stat(filename)
			vim.fn.jobstart({ "eslint_d", "--fix", filename }, {
				on_exit = function(_, exit_code)
					if exit_code ~= 0 then
						return
					end
					vim.schedule(function()
						local mtime_after = vim.uv.fs_stat(filename)
						if mtime_after and mtime_before and mtime_after.mtime.sec ~= mtime_before.mtime.sec then
							vim.cmd("silent! edit!")
						end
					end)
				end,
			})
		end
	end,
})

-- Lint trigger
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	callback = function()
		local filetype = vim.bo.filetype
		if filetype ~= "rust" then
			require("lint").try_lint()
		end
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
		python = { "ruff_fix", "ruff_format" },
		lua = { "stylua" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
		proto = { "buf" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		hcl = { "terraform_fmt" },
		["terraform-vars"] = { "terraform_fmt" },
	},
	format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
	formatters = {
		prettier = {
			env = { PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/prettierrc.json") },
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				local project = helpers.detect_project_type(root_dir)
				if vim.bo.filetype == "markdown" then
					return true
				end
				return project.has_prettier or project.is_cdk
			end,
			prepend_args = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				if helpers.has_project_files({ "tailwind.config.js", "tailwind.config.ts" }, root_dir) then
					return { "--plugin", "prettier-plugin-tailwindcss" }
				end
				return {}
			end,
		},
		ruff_fix = {
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				return helpers.detect_project_type(root_dir).has_python
			end,
		},
		ruff_format = {
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				return helpers.detect_project_type(root_dir).has_python
			end,
		},
		terraform_fmt = {
			condition = function(ctx)
				local root_dir = ctx.root or vim.fn.getcwd() or ""
				return helpers.detect_project_type(root_dir).has_terraform
			end,
		},
	},
})
