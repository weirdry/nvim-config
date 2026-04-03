local M = {}

function M.has_project_files(files, root_dir)
	root_dir = root_dir or vim.fn.getcwd()
	for _, file in ipairs(files) do
		if file:match("%*") then
			local glob_files = vim.fn.glob(root_dir .. "/" .. file, 0, 1)
			if #glob_files > 0 then
				return true
			end
		else
			if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
				return true
			end
		end
	end
	return false
end

function M.detect_project_type(root_dir)
	root_dir = root_dir or vim.fn.getcwd()

	local frontend_files = {
		"tailwind.config.js",
		"tailwind.config.ts",
		"next.config.js",
		"nuxt.config.js",
		"vite.config.js",
		"webpack.config.js",
	}
	local backend_files = { "nest-cli.json", "tsconfig.build.json" }
	local cdk_files = { "cdk.json" }
	local eslint_files =
		{ "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
	local prettier_files =
		{ ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yml", "prettier.config.js" }
	local python_files = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".python-version" }
	local terraform_files = { "main.tf", "variables.tf", "outputs.tf", "terraform.tf", "*.tf", "*.tfvars" }

	return {
		is_frontend = M.has_project_files(frontend_files, root_dir),
		is_backend = M.has_project_files(backend_files, root_dir),
		is_cdk = M.has_project_files(cdk_files, root_dir),
		has_eslint = M.has_project_files(eslint_files, root_dir),
		has_prettier = M.has_project_files(prettier_files, root_dir),
		has_python = M.has_project_files(python_files, root_dir),
		has_terraform = M.has_project_files(terraform_files, root_dir),
	}
end

return M
