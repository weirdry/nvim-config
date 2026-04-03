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

vim.keymap.set("n", "<leader>cr", function() run_cargo_cmd("cargo run") end, { desc = "Cargo Run" })
vim.keymap.set("n", "<leader>ct", function() run_cargo_cmd("cargo test") end, { desc = "Cargo Test" })
vim.keymap.set("n", "<leader>cc", function() run_cargo_cmd("cargo check") end, { desc = "Cargo Check" })
vim.keymap.set("n", "<leader>cb", function() run_cargo_cmd("cargo build") end, { desc = "Cargo Build" })
vim.keymap.set("n", "<leader>cC", function() run_cargo_cmd("cargo clippy") end, { desc = "Cargo Clippy" })
vim.keymap.set("n", "<leader>cw", function() run_cargo_cmd("cargo watch -x check") end, { desc = "Cargo Watch" })
vim.keymap.set("n", "<leader>cf", function() run_cargo_cmd("cargo fmt") end, { desc = "Cargo Format" })
vim.keymap.set("n", "<leader>cd", function() run_cargo_cmd("cargo doc --open") end, { desc = "Cargo Doc" })

vim.keymap.set("n", "<leader>cR", function()
	local args = vim.fn.input("cargo run arguments: ")
	run_cargo_cmd(args ~= "" and "cargo run " .. args or "cargo run")
end, { desc = "Cargo Run with args" })
vim.keymap.set("n", "<leader>cT", function()
	local test_name = vim.fn.input("Test name (optional): ")
	run_cargo_cmd(test_name ~= "" and "cargo test " .. test_name or "cargo test")
end, { desc = "Cargo Test specific" })

vim.keymap.set("n", "<leader>crh", function() run_cargo_cmd("cargo run", { direction = "horizontal" }) end, { desc = "Cargo Run (horizontal)" })
vim.keymap.set("n", "<leader>crv", function() run_cargo_cmd("cargo run", { direction = "vertical" }) end, { desc = "Cargo Run (vertical)" })

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
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
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
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "<leader>fs", function() require("flash").treesitter() end, { desc = "Search Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end)
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end)

-- hlslens
local hlslens = require("hlslens")
vim.keymap.set("n", "n", function()
	vim.cmd.execute("'normal! ' . v:count1 . 'n'")
	hlslens.start()
end, { desc = "Next search result" })
vim.keymap.set("n", "N", function()
	vim.cmd.execute("'normal! ' . v:count1 . 'N'")
	hlslens.start()
end, { desc = "Previous search result" })
vim.keymap.set("n", "*", function() vim.cmd("normal! *"); hlslens.start() end, { desc = "Search word forward" })
vim.keymap.set("n", "#", function() vim.cmd("normal! #"); hlslens.start() end, { desc = "Search word backward" })
vim.keymap.set("n", "g*", function() vim.cmd("normal! g*"); hlslens.start() end, { desc = "Search partial word forward" })
vim.keymap.set("n", "g#", function() vim.cmd("normal! g#"); hlslens.start() end, { desc = "Search partial word backward" })

vim.keymap.set("n", "<Esc><Esc>", "<Cmd>noh<CR>", { desc = "Clear search highlights" })

-- Noice
vim.keymap.set("n", "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice History" })
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
vim.keymap.set("n", "<leader>sv", function() require("swenv.api").pick_venv() end, { desc = "Select virtual environment" })

-- Terraform commands
local function run_terraform_cmd(cmd)
	local term = require("toggleterm.terminal").Terminal:new({
		cmd = cmd,
		direction = "float",
		close_on_exit = false,
		auto_scroll = true,
	})
	term:toggle()
end

vim.keymap.set("n", "<leader>ti", function() run_terraform_cmd("terraform init") end, { desc = "Terraform Init" })
vim.keymap.set("n", "<leader>tp", function() run_terraform_cmd("terraform plan") end, { desc = "Terraform Plan" })
vim.keymap.set("n", "<leader>ta", function() run_terraform_cmd("terraform apply") end, { desc = "Terraform Apply" })
vim.keymap.set("n", "<leader>tv", function() run_terraform_cmd("terraform validate") end, { desc = "Terraform Validate" })

-- which-key registration
require("which-key").add({
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
	{ "<leader>t", group = "Terraform" },
	{ "<leader>n", group = "Noice" },
})
