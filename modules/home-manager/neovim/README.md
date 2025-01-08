# Neovim Configuration Guide

<img src="./assets/neovim-dashboard.png" width="800" alt="Neovim Dashboard">

## Table of Contents
- [Keybindings Overview](#keybindings-overview)
  - [Core Navigation](#core-navigation)
  - [File and Buffer Management](#file-and-buffer-management)
  - [Window Management](#window-management)
  - [File Navigation and Search](#file-navigation-and-search)
  - [Git Commands](#git-commands)
  - [Code Navigation](#code-navigation)
  - [Code Actions](#code-actions)
  - [Session Management](#session-management)
  - [Text Objects](#text-objects)
- [Completion and Snippets](#completion-and-snippets)
- [LSP Features](#lsp-features)
- [AI Assistance](#ai-assistance)
- [File Explorers](#file-explorers)
- [Plugin Features](#plugin-features)

## Keybindings Overview

### Core Navigation
| Shortcut | Description |
|----------|-------------|
| `<C-h/j/k/l>` | Navigate splits/windows |
| `<leader>p/n` | Previous/Next buffer |

### File and Buffer Management
| Shortcut | Description |
|----------|-------------|
| `<leader>bb` | Browse buffers (Telescope) |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete buffer and window |
| `<leader>bo` | Delete other buffers |
| `<leader>br` | Delete buffers to the right |
| `<leader>be` | Buffer explorer |

### Window Management
| Shortcut | Description |
|----------|-------------|
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |
| `<leader>se` | Make splits equal size |
| `<leader>sx` | Close current split |
| `<leader>wd` | Delete window |
| `<leader>wm` | Enable maximize |

### File Navigation and Search
| Shortcut | Description |
|----------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fh` | Help tags |
| `<leader>fn` | New file |
| `<leader>fr` | Recent files |
| `<leader>fR` | Recent files (cwd) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fe` | Explorer NeoTree (root dir) |
| `<leader>fE` | Explorer NeoTree (cwd) |
| `<leader>fc` | Find config file |
| `<leader>ft` | Terminal (root dir) |
| `<leader>fT` | Terminal (cwd) |
| `<leader>fy` | Clipboard history |

### File Explorers
| Shortcut | Description |
|----------|-------------|
| `<leader>ee` | Open Neo-tree Explorer |
| `<leader>ef` | Find Current File in Neo-tree |
| `<leader>et` | Toggle Neo-tree Explorer |
| `<leader>eg` | Neo-tree Git Status |
| `<leader>mf` | Mini Files (Current File) |
| `<leader>md` | Mini Files (Directory) |
| `<leader>mh` | Mini Files (Home) |
| `<leader>mc` | Mini Files (Config) |

### Git Integration
| Shortcut | Description |
|----------|-------------|
| `<leader>gg` | Open LazyGit |
| `<leader>gc` | Open LazyGit Config |
| `<leader>gf` | Open LazyGit Current File |
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### LSP Features
| Shortcut | Description |
|----------|-------------|
| `<leader>ld` | Go to definition |
| `<leader>lr` | Find references |
| `<leader>li` | Go to implementation |
| `<leader>lt` | Go to type definition |
| `<leader>ls` | Document symbols |
| `<leader>lw` | Workspace symbols |
| `<leader>ln` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>lk` | Hover documentation |
| `<leader>lD` | Go to declaration |
| `<leader>lwa` | Add workspace folder |
| `<leader>lwr` | Remove workspace folder |
| `<leader>lwl` | List workspace folders |

## Completion and Snippets

The configuration uses nvim-cmp as the main completion engine with multiple sources:

### Completion Sources (In Priority Order)
1. LSP (1000) - Language Server completions
2. Lua (900) - Neovim Lua API
3. Snippets (800) - LuaSnip snippets
4. Path (700) - Filesystem paths
5. Emoji (600) - Emoji completions
6. Buffer (500) - Words from current buffer
7. Codeium (100) - AI-powered suggestions

### Key Bindings
| Shortcut | Description |
|----------|-------------|
| `<C-Space>` | Open completion menu |
| `<C-e>` | Close completion menu |
| `<C-y>` | Confirm completion |
| `<C-j/k>` | Navigate completion items |
| `<C-f/b>` | Scroll docs |
| `<Tab>` | Next completion/Expand snippet |
| `<S-Tab>` | Previous completion |

### AI Assistance (Codeium)
| Shortcut | Description |
|----------|-------------|
| `<M-l>` | Accept suggestion |
| `<M-w>` | Accept word |
| `<M-CR>` | Accept line |
| `<M-c>` | Clear suggestions |
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |

## LSP Features

The configuration includes comprehensive LSP support with the following features:

### Language Servers
- Lua (`lua_ls`)
- Rust (`rust-analyzer`)
- Python (`pylsp`)
- TypeScript/JavaScript (`ts_ls`)
- Nix (`nixd`)
- And many more basic servers

### Special LSP Configurations
- **Rust**: Enhanced with inlay hints, clippy integration, and cargo features
- **Nix**: Configured with nixd for better completion and diagnostics
- **Python**: Minimal configuration focusing on core features
- **Lua**: Configured specifically for Neovim Lua development

### Features
- Automatic formatting on save (where supported)
- Document highlighting
- Folding support (language-specific)
- Diagnostic display with virtual text
- Code action support
- Workspace folder management
- Signature help

## Plugin Features

The configuration includes several key plugins for enhanced functionality:

### File Management
- **mini.files**: Enhanced file explorer with git status integration
- **neo-tree**: Tree-style file explorer with git integration

### Git Integration
- **LazyGit**: Full git interface
- **gitsigns**: In-buffer git information

### Completion and Snippets
- **nvim-cmp**: Main completion engine
- **LuaSnip**: Snippet engine
- **friendly-snippets**: Community snippet collection

### UI Enhancements
- **lspkind**: VS Code-like pictograms
- **noice**: UI improvements for cmdline and notifications
- **fidget**: LSP progress information

### Navigation
- **telescope**: Fuzzy finder and picker
- **harpoon**: Quick file navigation

### Code Understanding
- **treesitter**: Advanced syntax highlighting
- **nvim-lspconfig**: LSP configuration

### AI Integration
- **codeium**: AI-powered code completion
