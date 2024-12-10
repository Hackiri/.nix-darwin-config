# Neovim Configuration Guide

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
- [Telescope](#telescope-shortcuts)
- [Treesitter](#treesitter-configuration)
- [Buffer Management](#buffer-management)
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

## Plugin Features

### Which Key
- Provides interactive key binding hints
- Shows available commands based on prefix
- Organizes commands into groups:
  - `<leader>f`: Find/Files operations
  - `<leader>g`: Git operations
  - `<leader>l`: LSP operations
  - `<leader>s`: Surround operations

### Mini.nvim Suite
- **Mini.files**: Fast and minimal file explorer
- **Mini.surround**: Surround text operations
- **Mini.comment**: Smart commenting
- **Mini.pairs**: Auto-pair brackets and quotes
- **Mini.ai**: Enhanced text objects
- **Mini.move**: Move lines and blocks
- **Mini.indentscope**: Show indent scope
- **Mini.starter**: Custom start screen

### Additional Features
- **Telescope**: Fuzzy finder and picker
- **Treesitter**: Advanced syntax highlighting
- **Neo-tree**: File explorer with git integration
- **Gitsigns**: Git integration in buffer
- **Noice**: Enhanced UI notifications
- **Codeium**: AI code completion
- **Which-key**: Interactive key binding help
