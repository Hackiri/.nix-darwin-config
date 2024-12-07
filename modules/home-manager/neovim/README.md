# Neovim Configuration Guide

## Table of Contents
- [Keybindings Overview](#keybindings-overview)
  - [Core Navigation](#core-navigation)
  - [File and Buffer Management](#file-and-buffer-management)
  - [Window Management](#window-management)
  - [File Navigation and Search](#file-navigation-and-search)
  - [Git Commands](#git-commands)
    - [Git Status Window](#inside-git-status-window)
    - [Git Commit Window](#inside-git-commit-window)
  - [Code Navigation](#code-navigation)
  - [Code Actions](#code-actions)
  - [Session Management](#session-management)
  - [Text Objects](#text-objects)
- [Telescope](#telescope-shortcuts)
  - [Main Search Commands](#main-search-commands-normal-mode)
  - [Telescope Window Controls](#within-telescope-window)
  - [Special Features](#special-features)
- [Treesitter](#treesitter-configuration)
  - [Incremental Selection](#incremental-selection)
  - [Text Objects](#text-objects-1)
  - [Supported Languages](#supported-language-groups)
- [Buffer Management](#buffer-management)
  - [Quick Navigation](#quick-buffer-navigation)
  - [Snipe Menu](#inside-snipe-buffer-menu)
  - [Telescope Browser](#inside-telescope-buffer-browser)
- [Snipe.nvim](#snipenvim)
- [Tmux Navigator](#tmux-navigator)
- [Mini.files](#minifiles)
- [Neo-tree](#neo-tree)
- [Mini.surround](#minisurround)
- [Mini.comment](#minicomment)
- [Mini.pairs](#minipairs)
- [Mini.ai](#miniai)
- [Mini.move](#minimove)
- [Mini.bufremove](#minibufremove)
- [Mini.indentscope](#miniindentscope)
- [Mini.starter](#ministarter)
- [Mini.hipatterns](#minihibackground)
- [Mini.animate](#minianimate)

## Keybindings Overview

### Core Navigation
| Shortcut | Description |
|----------|-------------|
| `<C-h/j/k/l>` | Navigate splits/windows |
| `<leader>p/n` | Previous/Next buffer |
| `<S-l>` | Quick buffer switch (Snipe) |

### File and Buffer Management
| Shortcut | Description |
|----------|-------------|
| `<leader>bb` | Browse buffers (Telescope) |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete buffer and window |
| `<leader>bo` | Delete other buffers |
| `<leader>br` | Delete buffers to the right |
| `<leader>bP` | Delete non-pinned buffers |
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

### Git Commands
| Shortcut | Description |
|----------|-------------|
| `<leader>gf` | Search git files |
| `<leader>lg` | LazyGit |
| `<leader>ngs` | NeoTree git status |
| `<leader>gs` | Git status |
| `<leader>ga` | Git add current file |
| `<leader>gA` | Git add all files |
| `<leader>gc` | Git commit (opens detailed commit window) |
| `<leader>gp` | Git push |
| `<leader>gP` | Git pull |
| `<leader>gb` | Git branches |
| `<leader>gB` | Git blame |
| `<leader>gh` | Git history of current file |
| `<leader>gH` | Git history of repo |
| `<leader>gd` | Git diff of current file |
| `<leader>gD` | Git diff of staged changes |

### Inside Git Status Window
| Shortcut | Description |
|----------|-------------|
| `<CR>` | Open file/directory |
| `-` | Toggle stage/unstage |
| `X` | Discard changes |
| `s` | Stage file/selection |
| `u` | Unstage file/selection |
| `q` | Close status window |

### Inside Git Commit Window
| Shortcut | Description |
|----------|-------------|
| `<leader>cc` | Create commit |
| `<leader>ca` | Amend last commit |
| `<leader>ce` | Edit commit message |
| `<leader>cw` | Write commit message |
| `<leader>cq` | Quit without committing |
| `<leader>cn` | Create commit (no verify) |

### Code Navigation
| Shortcut | Description |
|----------|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `<leader>r` | Toggle current file in NeoTree |

### Code Actions
| Shortcut | Description |
|----------|-------------|
| `gc` | Toggle comment |
| `gcc` | Toggle comment line |
| `gco` | Add comment below |
| `gcO` | Add comment above |
| `gsf` | Find right surrounding |
| `gsa` | Add surrounding |
| `gsr` | Replace surrounding |
| `gsd` | Delete surrounding |

### Session Management
| Shortcut | Description |
|----------|-------------|
| `<leader>qq` | Quit all |
| `<leader>ql` | Restore last session |
| `<leader>qs` | Restore session |
| `<leader>qS` | Select session |
| `<leader>qd` | Don't save current session |

### Text Objects
| Shortcut | Description |
|----------|-------------|
| `aa`/`ia` | Around/Inner parameter |
| `af`/`if` | Around/Inner function |
| `ac`/`ic` | Around/Inner class |
| `ai`/`ii` | Around/Inner conditional |
| `al`/`il` | Around/Inner loop |
| `ab`/`ib` | Around/Inner block |

### Overlapping Keymaps Note
Some keymaps share common prefixes but lead to different actions based on timing and subsequent keys:
- `<leader>b` prefixes buffer commands
- `<leader>f` prefixes file/find commands
- `<leader>w` prefixes window commands
- `<leader>q` prefixes quit/session commands
- `g` prefixes various goto/code actions

## Telescope Shortcuts

### Main Search Commands (Normal Mode)
| Shortcut | Description |
|----------|-------------|
| `<leader>sf` | [S]earch [F]iles: Find files in your project |
| `<leader>sg` | [S]earch by [G]rep: Live grep through files |
| `<leader>?` | Find recently opened files |
| `<leader><space>` | Find and switch between open buffers |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>gf` | Search [G]it [F]iles |
| `<leader>sw` | [S]earch current [W]ord under cursor |
| `<leader>sd` | [S]earch [D]iagnostics |
| `<leader>sr` | [S]earch [R]esume (reopen last search) |
| `<leader>sh` | [S]earch [H]elp tags |
| `<leader>ss` | [S]earch [S]elect Telescope pickers |

### Within Telescope Window

#### Insert Mode (`i`)
| Shortcut | Description |
|----------|-------------|
| `<C-j>` | Move selection down |
| `<C-k>` | Move selection up |
| `<C-n>` | Next search history |
| `<C-p>` | Previous search history |
| `<C-c>` or `<esc>` | Close telescope |
| `J` | Scroll preview down |
| `K` | Scroll preview up |

#### Normal Mode (`n`)
| Shortcut | Description |
|----------|-------------|
| `d` | Delete buffer (when viewing buffers) |
| `<esc>` | Close telescope |
| `J` | Scroll preview down |
| `K` | Scroll preview up |

### Special Features
- Files are sorted by most recently modified
- Dropdown theme for common operations
- File search ignores `node_modules`, `.git`, and `.venv` directories
- Fuzzy finding powered by `fzf` for fast searches

### Tips
1. Most searches use a dropdown theme for a clean interface
2. Use `<leader>sr` to quickly resume your last search
3. The live grep (`<leader>sg`) is great for searching file contents
4. Use `<leader>s/` to grep only in currently open files

Note: `<leader>` is typically the space key in most Neovim configurations.

## Treesitter Configuration

### Incremental Selection
| Shortcut | Description |
|----------|-------------|
| `<Leader>ts` | Start selection |
| `<Leader>ti` | Increment selection |
| `<Leader>td` | Decrement selection |
| `<Leader>tc` | Select container/scope |

### Text Objects
#### Selection
| Shortcut | Description |
|----------|-------------|
| `aa`/`ia` | Outer/Inner parameter |
| `af`/`if` | Outer/Inner function |
| `ac`/`ic` | Outer/Inner class |
| `ai`/`ii` | Outer/Inner conditional |
| `al`/`il` | Outer/Inner loop |
| `ab`/`ib` | Outer/Inner block |
| `a/`/`i/` | Outer/Inner call |

#### Navigation
| Shortcut | Description |
|----------|-------------|
| `]m`/`[m` | Next/Previous function start |
| `]M`/`[M` | Next/Previous function end |
| `]]`/`[[` | Next/Previous class start |
| `][`/`[]` | Next/Previous class end |
| `]i`/`[i` | Next/Previous conditional |
| `]l`/`[l` | Next/Previous loop |
| `]s`/`[s` | Next/Previous statement |

#### Swapping Elements
| Shortcut | Description |
|----------|-------------|
| `<leader>a`/`<leader>A` | Swap next/previous parameter |
| `<leader>f`/`<leader>F` | Swap next/previous function |
| `<leader>e`/`<leader>E` | Swap next/previous element |

### Supported Language Groups
1. **Web Development**
   - HTML, CSS, JavaScript, TypeScript, TSX, Vue, Svelte, GraphQL, JSON, XML

2. **Backend Development**
   - Python, Java, Go, Rust, Ruby, PHP, C/C++, C#, Kotlin, Scala

3. **System and DevOps**
   - Bash, Fish, Dockerfile, Terraform, HCL, Make, CMake, Perl, Regex, TOML, AWK

4. **Data and Config**
   - YAML, JSON, TOML, INI, SQL, GraphQL, Protocol Buffers

5. **Documentation and Markup**
   - Markdown, VimDoc, reStructuredText, LaTeX, BibTeX

6. **Version Control**
   - Git configs, attributes, commit messages, ignore files, diffs

7. **Scripting and Config**
   - Lua, Vim, Query, Regex, jq, Nix, Groovy

### Features
- Automatic installation of parsers
- Syntax highlighting
- Smart indentation
- Incremental selection
- Textobject support
- Auto-tag closing for web development
- Context-aware commenting
- Smart folding (disabled by default, use `zi` to toggle)

### File Type Associations
- Terraform: `.tf`, `.tfvars`, `.terraform`
- Groovy: `.pipeline`, `Jenkinsfile`, `.groovy`
- Python: `.py`, `.pyi`, `.pyx`, `.pxd`
- YAML: `.yaml`, `.yml`
- Dockerfile: `Dockerfile`, `.dockerfile`
- Ruby: `.rb`, `.rake`, `.gemspec`

## Buffer Management

### Quick Buffer Navigation
| Shortcut | Description |
|----------|-------------|
| `<S-l>` | Quick buffer switch with visual hints (Snipe) |
| `<leader>bb` | Browse buffers with preview (Telescope) |
| `<leader>p` | Previous buffer |
| `<leader>n` | Next buffer |

### Inside Snipe Buffer Menu
| Shortcut | Description |
|----------|-------------|
| `<esc>` | Cancel/close Snipe menu |
| `d` | Delete buffer under cursor |
| Letters | Jump to buffer with hint |

### Inside Telescope Buffer Browser
| Shortcut | Description |
|----------|-------------|
| `<C-d>` | Delete buffer (insert mode) |
| `dd` | Delete buffer (normal mode) |
| `<esc>` | Close browser |

### Features
- Visual hints for quick buffer switching (Snipe)
- Full buffer list with preview (Telescope)
- MRU (Most Recently Used) sorting
- Easy buffer deletion
- Preview window for buffer contents

## Snipe.nvim

Quick buffer switching with visual hints.

### Keybindings
| Shortcut | Description |
|----------|-------------|
| `<S-l>` | Quick buffer switch (Snipe) |
| `<esc>` | Cancel/close Snipe menu |
| `d` | Delete buffer under cursor |

### Features
- Visual hints for quick buffer switching
- MRU (Most Recently Used) sorting
- Easy buffer deletion
- Works alongside other buffer management tools

### Usage Tips
1. Use Snipe (`<S-l>`) for quick visual buffer switching
2. Use Telescope buffers (`<leader>bb`) when you need search and preview
3. Use `<leader>p`/`<leader>n` for previous/next buffer navigation
4. Use `<S-h>` for previous buffer

## Tmux Navigator

Seamlessly navigate between Neovim splits and Tmux panes using the same shortcuts.

### Navigation Shortcuts
| Shortcut | Description |
|----------|-------------|
| `<C-h>` | Navigate to the left split/pane |
| `<C-j>` | Navigate to the split/pane below |
| `<C-k>` | Navigate to the split/pane above |
| `<C-l>` | Navigate to the right split/pane |

### Features
- Seamless navigation between Neovim splits and Tmux panes
- Consistent keybindings across both environments
- Smart detection of split boundaries
- Works in both normal and visual modes

### Tips
1. These shortcuts work the same way whether you're in a Neovim split or a Tmux pane
2. The navigation is context-aware - it will move to a Tmux pane if there are no more Neovim splits in that direction
3. Use these shortcuts instead of the traditional Vim split navigation commands for better consistency

## Mini.files

Mini Files is a lightweight file explorer that complements Neo-tree with quick file browsing and preview capabilities.

### Keybindings
| Shortcut | Description |
|----------|-------------|
| `<leader>m` | Open Mini Files at current directory |
| `<leader>M` | Open Mini Files at current file |

### Features
- Quick file browsing with preview
- Git status integration
- Trash support for safe deletions
- Complementary to Neo-tree

### Within Mini Files Window
| Shortcut | Description |
|----------|-------------|
| `<CR>` | Open file/directory |
| `g?` | Show help |
| `<C-s>` | Split horizontally |
| `<C-v>` | Split vertically |
| `.` | Show hidden files |
| `y` | Copy entry path |
| `x` | Delete entry to trash |
| `R` | Rename entry |
| `H` | Show history |

## Neo-tree

Neo-tree is the primary file explorer with rich features and Git integration.

### Keybindings
| Shortcut | Description |
|----------|-------------|
| `<leader>e` | Toggle Neo-tree |
| `\` | Toggle Neo-tree with current file |
| `<leader>ngs` | Open Neo-tree Git status |

### Features
- File system browser
- Git status integration
- Buffer list view
- Document symbols
- Multiple view modes (side panel, float)
- File operations with notifications

### Within Neo-tree Window
| Shortcut | Description |
|----------|-------------|
| `<CR>` | Open file/directory |
| `o` | Open file |
| `O` | Open with window picker |
| `a` | Add file/directory |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `y` | Copy entry path |
| `Y` | Copy relative path |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `c` | Copy file/directory |
| `m` | Move file/directory |
| `R` | Refresh |
| `?` | Show help |
| `<C-x>` | Open split horizontal |
| `<C-v>` | Open split vertical |
| `<C-t>` | Open in new tab |
| `<BS>` | Close node |
| `z` | Close all nodes |
| `Z` | Close all nodes recursively |
| `E` | Toggle auto-expand mode |

## Mini.surround

## Mini.comment

## Mini.pairs

## Mini.ai

## Mini.move

## Mini.bufremove

## Mini.indentscope

## Mini.starter

## Mini.hipatterns

## Mini.animate
