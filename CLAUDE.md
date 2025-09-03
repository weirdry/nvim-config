# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modern Neovim configuration optimized for **TypeScript, Python, Go, Rust, and Protocol Buffers** development. It provides IDE-like features with comprehensive LSP support, built on top of lazy.nvim for fast startup times and the Tokyo Night theme for a modern aesthetic.

## Architecture

The configuration is structured as a single-file setup (`nvim/init.lua`) with several key architectural components:

### Core Infrastructure

- **Plugin Management**: Uses lazy.nvim with lazy loading for optimal performance
- **Theme**: Tokyo Night "storm" style with terminal colors and italic comments/keywords
- **UI Components**: lualine (status line), bufferline (buffer tabs), nvim-navic (breadcrumb), barbecue (context breadcrumbs)
- **LSP Foundation**: Built on nvim-lspconfig with project-specific detection and configuration

### Key Design Patterns

- **Project Detection**: Smart detection of project types (frontend, backend, CDK, Python) via `detect_project_type()` function
- **Conditional Tool Loading**: Tools and formatters are conditionally enabled based on project configuration files
- **VS Code Integration**: Reads `.vscode/settings.json` for TailwindCSS patterns and spell check words
- **Performance Optimization**: Large file detection with automatic syntax/TreeSitter disabling

### Language-Specific Integrations

- **TypeScript/JavaScript**: Custom ESLint integration using `eslint_d` for fast auto-fixing
- **Rust**: Modern development with rustaceanvim for real-time diagnostics, background testing, and enhanced LSP features
- **Go**: Uses go.nvim for advanced Go development features
- **Python**: Virtual environment management with swenv.nvim
- **Protocol Buffers**: Modern buf CLI integration with real-time LSP diagnostics and formatting

## Common Development Commands

### Basic Usage

- Launch Neovim: `nvim`
- The configuration will auto-install plugins on first launch via Mason and lazy.nvim

### Testing and Building

This is a Neovim configuration repository - there are no build or test commands. The configuration is tested by launching Neovim and verifying plugin functionality.

### LSP and Tool Management

- `:Mason` - Manage LSP servers and development tools
- `:Lazy` - Manage plugins and view loading performance
- `:checkhealth` - Check Neovim and plugin health
- `:LspInfo` - Check LSP server status and connections

### Navigation and Search Tools

- **Telescope**: Fuzzy finder with nvim-navic integration for winbar
- **nvim-tree**: File explorer with git integration and custom filtering (.DS_Store, node_modules, dist excluded)
- **Flash**: Lightning-fast navigation with custom label sequence (asdfghjklqwertyuiopzxcvbnm)
- **Harpoon v2**: Quick file bookmarking and navigation
- **Aerial**: Code outline and structure navigation

### Code Analysis and Highlighting

- **TreeSitter**: Syntax highlighting for TypeScript, JavaScript, TSX, HTML, CSS, Lua, Python, Go, Rust, TOML, Proto
- **nvim-lint**: Language-specific linting with conditional loading (excludes Rust)
- **conform.nvim**: Formatting with timeout and LSP fallback
- **indent-blankline**: Visual indentation guides with scope highlighting

### Debugging and Testing

- **nvim-dap**: Multi-language debugging with DAP protocol
- **nvim-dap-ui**: Interactive debugging interface with auto-open/close
- **nvim-dap-python**: Python debugging with virtualenv support (~/.virtualenvs/debugpy/bin/python)
- **codelldb**: Rust debugging adapter via Mason

### Git Integration

- **vim-fugitive**: Complete Git workflow integration
- **gitsigns**: Real-time Git change indicators in sign column
- **diffview.nvim**: Advanced diff viewing and conflict resolution
- **git-conflict.nvim**: Inline conflict resolution with highlighting

### UI/UX Enhancements

- **vim-visual-multi**: Multi-cursor editing with "ocean" theme
- **trouble.nvim**: Diagnostics, references, and quickfix management
- **noice.nvim**: Enhanced UI for messages, cmdline, and popups with notify disabled
- **nvim-surround**: Text object manipulation for quotes, brackets, etc.
- **nvim-hlslens**: Enhanced search highlighting with match count
- **vim-illuminate**: Highlight matching words under cursor with 100ms delay
- **neoscroll.nvim**: Smooth scrolling with cursor tracking and scrolloff respect
- **which-key.nvim**: Command palette and key binding hints
- **nvim-scrollview**: Scrollbar with diagnostic, search, and mark indicators

### Additional Utilities

- **markdown-preview.nvim**: Live markdown preview in browser
- **toggleterm.nvim**: Floating terminal with curved border (100x20, <C-\\> to toggle)
- **nvim-neoclip**: Clipboard history with 1000 entries and SQLite persistence
- **swenv.nvim**: Python virtual environment switcher with project .venv support
- **emmet-vim**: HTML/CSS expansion shortcuts
- **vim-cmake**: CMake project integration
- **Comment.nvim**: Intelligent code commenting
- **nvim-autopairs**: Automatic bracket, quote, and tag pairing with TreeSitter
- **nvim-colorizer**: Real-time color highlighting (RGB, HSL, CSS values)
- **todo-comments.nvim**: TODO/FIXME/HACK comment highlighting and search

### Rust Development Workflow (rustaceanvim)

- `:RustLsp explainError` - Explain error codes with detailed documentation
- `:RustLsp testables` - Run Rust tests with background diagnostics
- `:RustLsp debuggables` - Debug Rust applications
- `<leader>cr` - Cargo run
- `<leader>ct` - Cargo test
- `<leader>cc` - Cargo check
- `<leader>cb` - Cargo build
- `<leader>cC` - Cargo clippy
- `<leader>cf` - Cargo format
- `<leader>rh` - Toggle inlay hints

### Language Server Management

The configuration uses a hybrid approach for LSP servers:

- **Manual lspconfig setup**:
  - `ts_ls`: TypeScript/JavaScript with enhanced diagnostics and file location context
  - `tailwindcss`: With VS Code-compatible classAttributes and experimental classRegex patterns
  - `pyright`: Python with autoSearchPaths and openFilesOnly diagnostics
  - `gopls`: Go with staticcheck, gofumpt, and fuzzy matching
  - `buf_ls`: Protocol Buffers with real-time diagnostics via buf CLI
- **rustaceanvim**: Handles `rust-analyzer` automatically with enhanced features
- **Mason integration**: Auto-installs tools (black, isort, ruff, prettier, eslint_d, gopls, golangci-lint, gofumpt, goimports, codelldb, stylua, buf)

### Formatting and Linting Strategy

- **Formatting**: Uses conform.nvim with 3-second timeout and LSP fallback
  - **Prettier**: Conditional loading for projects with prettier config, TailwindCSS plugin integration
  - **Black**: Python formatting with line-length 88, preview mode, and string processing
  - **Other formatters**: stylua (Lua), gofumpt+goimports (Go), rustfmt (Rust), buf (Protocol Buffers)
- **Linting**: Uses nvim-lint with conditional loading based on project type, excluding Rust and Protocol Buffers
  - **ESLint**: For JS/TS projects with conditional loading based on project detection
  - **Custom golangci-lint**: JSON output parsing with issue position mapping
  - **Ruff**: For Python projects
  - **Protocol Buffers**: Real-time linting via buf_ls LSP (not nvim-lint)
- **ESLint Integration**: Uses `eslint_d` directly for fast auto-fixing on save (matches VS Code "source.fixAll.eslint": "explicit")
- **Rust Linting**: Disabled clippy in nvim-lint - rustaceanvim provides comprehensive diagnostics

## Project Structure

```
nvim/
├── nvim/
│   ├── init.lua           # Main configuration file (all-in-one)
│   └── lazy-lock.json     # Plugin version lock file
├── README.md              # Comprehensive documentation
├── CLAUDE.md              # Development guidance for Claude Code
├── .gitignore             # Git ignore patterns
└── screenshots/           # Configuration screenshots
```

## Key Configuration Details

### Helper Functions

- `has_project_files()` - Checks for existence of project configuration files
- `detect_project_type()` - Returns project characteristics (frontend, backend, CDK, etc.)

### Performance Optimizations

- **Large file detection** (>1MB) with syntax/TreeSitter disabling
- **Large Rust file detection** (>5000 lines) with TreeSitter highlighting disabled
- **Pre-initialization of formatters** on startup (black, isort, prettier, eslint, ruff)
- **Lazy loading** for most plugins
- **Config file optimization** to prevent freezing (LspStop + TSBufDisable for init.lua)
- **Rust-specific performance**: LSP log level set to WARN for large files
- **Language-specific indentation**: Python (4 spaces), Go (4 tabs), Rust (4 spaces), TOML (2 spaces), Proto (2 spaces)

### Advanced Integrations

- **Terminal configuration**: Custom escape sequences (<Esc><Esc>) and window navigation
- **VS Code spell check import**: Automatically reads .vscode/settings.json cSpell.words and creates project-specific spell files
- **Custom commands**: `:RustNewProject` for quick Rust project creation
- **Winbar integration**: Custom highlighting and nvim-navic breadcrumb display
- **Diagnostic configuration**: Custom icons (󰅚 error, 󰀦 warn, 󰋼 info, 󰌶 hint) with virtual text and float settings

### VS Code Compatibility Features

- Automatic `.vscode/settings.json` parsing for TailwindCSS patterns
- Custom spell check word import from VS Code cSpell configuration
- ESLint auto-fix behavior matching VS Code's "source.fixAll.eslint": "explicit"

### Language-Specific Notes

- **Rust**: Uses rustaceanvim with rustup-installed tools for real-time diagnostics, background test execution, and enhanced error explanations. Includes `:RustNewProject` command for quick project creation.
- **TypeScript**: Enhanced diagnostic messages with file location context and location information
- **Go**: Integrated with go.nvim for advanced features and auto-formatting with goimports on save
- **Python**: Virtual environment detection and management with project-specific .venv support
- **Protocol Buffers**: Uses modern buf CLI workflow with buf_ls LSP for real-time diagnostics, automatic formatting with `buf format`, and 2-space indentation following Protocol Buffer conventions

## Development Workflow

When working with this configuration:

1. **Adding New Languages**:
   - Add LSP server to mason-tool-installer ensure_installed list
   - Configure LSP in the LSP settings section
   - Add formatters/linters to respective sections
   - Add language-specific autocmds if needed

2. **Plugin Management**:
   - All plugins are configured within the lazy.nvim setup block
   - Each plugin has isolated configuration
   - Use `:Lazy profile` to analyze loading performance

3. **Troubleshooting**:
   - Use `:checkhealth` for comprehensive system checks
   - Use `:checkhealth rustaceanvim` specifically for Rust development issues
   - Check `:LspInfo` for language server issues
   - Use `:Telescope diagnostics` for project-wide issue overview
   - For Rust: `:RustLsp logFile` to view rust-analyzer logs

## Rust Development Best Practices

### Real-time Diagnostics

- rustaceanvim provides real-time diagnostics automatically - no LSP restarts needed
- Background test execution shows failed tests as diagnostics
- Use `:RustLsp explainError` for detailed error explanations with documentation

### Tool Management

- **Always use rustup for Rust tools**: `rustup component add rust-analyzer clippy rustfmt`
- **Never install rust-analyzer via Mason** - causes conflicts with rustaceanvim
- Use `:checkhealth rustaceanvim` to verify proper setup

### Project Structure

- Works best within proper Cargo workspaces
- Limited functionality with standalone .rs files
- Cargo.toml changes are handled automatically by rustaceanvim

## Key Mappings Overview

### Core Navigation

- **Leader key**: `<Space>`
- **File operations**: `<leader>ft` (toggle tree), `<leader>ff` (find files), `<leader>fg` (live grep)
- **Buffer management**: `<Tab>` (next), `<S-Tab>` (prev), `<leader>bc` (pick close), `<leader>bo` (close others)
- **Harpoon**: `<leader>ha` (add), `<leader>hm` (menu), `<leader>h1-4` (select), `<leader>hp/hn` (prev/next)

### Development Tools

- **LSP**: `gd` (definition), `gr` (references), `gi` (implementation), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code action)
- **Diagnostics**: `[d`/`]d` (prev/next), `<leader>e` (show), `<leader>q` (list)
- **Trouble**: `<leader>xx` (diagnostics), `<leader>xX` (buffer diagnostics), `<leader>cs` (symbols)
- **Search**: `s` (flash jump), `<leader>fs` (flash treesitter), enhanced hlslens with `n`/`N`

### Terminal and Utilities

- **Terminal**: `<C-\>` (toggle float), `<Esc><Esc>` (exit terminal mode)
- **Miscellaneous**: `<leader>a` (aerial), `<leader>sv` (select venv), `<leader>fn` (neoclip)

### Cargo Integration (Rust)

- **Basic**: `<leader>cr` (run), `<leader>ct` (test), `<leader>cc` (check), `<leader>cb` (build)
- **Advanced**: `<leader>cC` (clippy), `<leader>cf` (format), `<leader>cw` (watch), `<leader>cd` (doc)
- **Interactive**: `<leader>cR` (run with args), `<leader>cT` (specific test)
- **Direction-specific**: `<leader>crh` (horizontal), `<leader>crv` (vertical)

