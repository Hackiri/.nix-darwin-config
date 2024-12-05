return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    -- Define language groups for better organization
    local language_groups = {
      -- Web Development
      web = {
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "svelte",
        "graphql",
        "json",
        "jsonc",
        "xml",
      },
      -- Backend Development
      backend = {
        "python",
        "java",
        "go",
        "rust",
        "ruby",
        "php",
        "c",
        "cpp",
        "c_sharp",
        "kotlin",
        "scala",
      },
      -- System and DevOps
      system = {
        "bash",
        "fish",
        "dockerfile",
        "terraform",
        "hcl",
        "make",
        "cmake",
        "perl",
        "regex",
        "toml",
        "awk",
      },
      -- Data and Config
      data = {
        "yaml",
        "json",
        "toml",
        "ini",
        "sql",
        "graphql",
        "proto",
      },
      -- Documentation and Markup
      docs = {
        "markdown",
        "markdown_inline",
        "vimdoc",
        "rst",
        "latex",
        "bibtex",
      },
      -- Version Control
      vcs = {
        "git_config",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "diff",
      },
      -- Scripting and Config
      scripting = {
        "lua",
        "vim",
        "query",
        "regex",
        "jq",
        "nix",
        "groovy",
      },
    }

    -- Flatten language groups into a single list
    local ensure_installed = {}
    for _, group in pairs(language_groups) do
      for _, lang in ipairs(group) do
        table.insert(ensure_installed, lang)
      end
    end

    require("nvim-treesitter.configs").setup({
      -- Basic Setup
      ensure_installed = ensure_installed,
      auto_install = true,
      sync_install = false,
      ignore_install = {},

      -- Required modules field
      modules = {},

      -- Highlighting
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },

      -- Indentation
      indent = {
        enable = true,
        disable = {},
      },

      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Leader>ts", -- treesitter start selection
          node_incremental = "<Leader>ti", -- treesitter increment
          node_decremental = "<Leader>td", -- treesitter decrement
          scope_incremental = "<Leader>tc", -- treesitter container/scope
        },
      },

      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Parameter/Argument text objects
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",

            -- Function text objects
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            -- Class text objects
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",

            -- Conditional text objects
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",

            -- Loop text objects
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",

            -- Block text objects
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",

            -- Call text objects
            ["a/"] = "@call.outer",
            ["i/"] = "@call.inner",
          },
        },

        -- Moving between text objects
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]s"] = "@statement.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
            ["[s"] = "@statement.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },

        -- Swapping elements
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
            ["<leader>f"] = "@function.outer",
            ["<leader>e"] = "@element",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
            ["<leader>F"] = "@function.outer",
            ["<leader>E"] = "@element",
          },
        },
      },

      -- Additional modules
      autotag = {
        enable = true,
      },

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })

    -- File type associations
    local filetypes = {
      terraform = { "tf", "tfvars", "terraform" },
      groovy = { "pipeline", "Jenkinsfile", "groovy" },
      python = { "py", "pyi", "pyx", "pxd" },
      yaml = { "yaml", "yml" },
      dockerfile = { "Dockerfile", "dockerfile" },
      ruby = { "rb", "rake", "gemspec" },
    }

    for filetype, extensions in pairs(filetypes) do
      for _, ext in ipairs(extensions) do
        vim.filetype.add({ extension = { [ext] = filetype } })
      end
    end

    -- Folding configuration
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
    vim.opt.foldlevel = 99
  end,
}
