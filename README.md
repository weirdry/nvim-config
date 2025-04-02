# Neovim Configuration

A modern, IDE-like Neovim configuration with full LSP support, optimized for TypeScript and Python development featuring the Tokyo Night theme.

![Neovim Screenshot](./screenshots/screenshot.webp)

## Features

- 🚀 [lazy.nvim](https://github.com/folke/lazy.nvim) as a fast, modern plugin manager
- 🌙 [Tokyo Night](https://github.com/folke/tokyonight.nvim) color scheme for a clean, modern look
- 🔍 Full LSP integration via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  - TypeScript/JavaScript
  - Python
  - Go
  - Tailwind CSS
  - And more!
- 📊 Syntax highlighting with [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- 🔎 Fuzzy finding with [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- 📁 File navigation with [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- 📝 Auto-completion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- 🚀 Go development environment with [go.nvim](https://github.com/ray-x/go.nvim)
- 🐛 Debugging support with [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- 💅 Code formatting with [conform.nvim](https://github.com/stevearc/conform.nvim)
- 🔬 Linting with [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- 🔄 Git integration with [gitsigns](https://github.com/lewis6991/gitsigns.nvim)
- 📑 Enhanced UI with [bufferline](https://github.com/akinsho/bufferline.nvim), [lualine](https://github.com/nvim-lualine/lualine.nvim), and [barbecue](https://github.com/utilyre/barbecue.nvim)
- ⚡ Fast navigation with [harpoon](https://github.com/ThePrimeagen/harpoon)
- 🎭 Terminal integration with [toggleterm](https://github.com/akinsho/toggleterm.nvim)

## System Requirements

- Neovim >= 0.9.0 (0.10+ recommended)
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope file search
- [fd](https://github.com/sharkdp/fd) for Telescope file finder
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- Node.js and npm (for LSP servers)
- Python 3 (for Python-related features)
- Go (for Go-related features)

## Installation

### 1. Backup your existing configuration (if any)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

### 2. Clone this repository

```bash
git clone https://github.com/weirdry/nvim-config.git ~/.config/nvim
```

### 3. Install plugins

Launch Neovim:

```bash
nvim
```

The plugins will be automatically installed on the first launch.

## Key Mappings

### General

- `<Space>` - Leader key
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search text)
- `<leader>fb` - Browse buffers
- `<Esc><Esc>` - Clear search highlights

### File Navigation

- `<leader>ft` - Toggle file explorer
- `<leader>fT` - Search TODOs

### LSP

- `gd` - Go to definition
- `gr` - Find references
- `gi` - Go to implementation
- `K` - Show hover information
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Buffers

- `<Tab>` - Next buffer
- `<S-Tab>` - Previous buffer
- `<leader>bc` - Close buffer (pick)
- `<leader>bo` - Close all other buffers

### Git

- Various git commands through fugitive (`:Git`)
- Gitsigns for inline git changes

### Diagnostics

- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>e` - Show diagnostic details
- `<leader>q` - Show diagnostic list

### Terminal

- `<C-\>` - Toggle terminal window

## Customization

This configuration is structured to be easily customizable:

- LSP servers are configured in the main `init.lua` file
- Formatters and linters are configured in the conform.nvim and nvim-lint sections
- Key mappings can be modified throughout the configuration

## Credits

Special thanks to the Neovim community and all the plugin authors that make this configuration possible.

## License

MIT
