-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',  -- latest stable release
    lazyrepo,
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

---------------
--- PLUGINS ---
---------------
-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- Colorscheme
    {
      "nordtheme/vim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme nord]])
      end,
    },

    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
        vim.keymap.set('n', '<F7>', '<cmd>NvimTreeToggle<CR>')
      end,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
        require("lualine").setup({
          options = {
            theme = 'nord',
            component_separators = { left = '|', right = '|'},
            section_separators = { left = '', right = ''},
          },
          sections = {
            lualine_c = {
              {
                'buffers',
                show_filename_only = false,
              }
            }
          }
        })
      end,
    },

    -- Highlight, edit, and navigate code
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ":TSUpdate", -- automatically update installed parses on plugin upgrades
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            'bash',
            'css',
            'go',
            'gomod',
            'html',
            'javascript',
            'json',
            'lua',
            'markdown',
            'markdown_inline',
            'python',
            'ruby',
            'typescript',
            'vimdoc',
            'vim',
            'yaml',
          },
          indent = { enable = true },
          -- Allows to select code incrementally, starting from a node and then expanding to broader scopes
          -- See: https://liam.rs/posts/Incremental-select-with-treesitter/
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<cr>", -- maps in normal mode to init the node/scope selection with space
              node_incremental = "<cr>", -- increment to the upper named parent
              node_decremental = "<bs>", -- decrement to the previous node
              scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
            },
          },
          highlight = {
            enable = true,

            -- Disable slow treesitter highlight for large files
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },

          textobjects = {
            -- Improve selection allowing to select by text object. (e.g. 'vic' -> select inside class)
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ["iB"] = "@block.inner",
                ["aB"] = "@block.outer",
              },
            },
            -- Improve jumps to allow easy code traversal from one class/function to the other
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']]'] = '@function.outer',
              },
              goto_next_end = {
                [']['] = '@function.outer',
              },
              goto_previous_start = {
                ['[['] = '@function.outer',
              },
              goto_previous_end = {
                ['[]'] = '@function.outer',
              },
            },
            -- Swap function parameters
            swap = {
              enable = true,
              swap_next = {
                ['<leader>sn'] = '@parameter.inner',
              },
              swap_previous = {
                ['<leader>sp'] = '@parameter.inner',
              },
            },
          },
        })
      end,
    },

    -- fzf extension for telescope with better speed
    {
      "nvim-telescope/telescope-fzf-native.nvim", build = 'make'
    },

    -- Sets vim.ui.select to telescope.
    -- That means for example that neovim core stuff can fill the telescope picker
    {'nvim-telescope/telescope-ui-select.nvim' },

    -- Fuzzy finder framework.
    -- See keybindings in the configuration section at the end of the file
    {
      "nvim-telescope/telescope.nvim",
      branch = '0.1.x',
      dependencies = {
        "nvim-lua/plenary.nvim" ,
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      config = function ()
        require("telescope").setup({
          extensions = {
            fzf = {
              fuzzy = true,                    -- false will only do exact matching
              override_generic_sorter = true,  -- override the generic sorter
              override_file_sorter = true,     -- override the file sorter
              case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                               -- the default case_mode is "smart_case"
            }
          }
        })

        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        require('telescope').load_extension('fzf')

        -- To get ui-select loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        require("telescope").load_extension("ui-select")
      end,
    },

    -- Community-defined LSP settings and custom overrides
    {
      "neovim/nvim-lspconfig",
      config = function ()
        util = require "lspconfig/util"

        local capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- Ruby (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruby_lsp)
        require'lspconfig'.ruby_lsp.setup{}

        -- Emmet (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#emmet_language_server)
        require'lspconfig'.emmet_language_server.setup{}

        -- TailwindCSS (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss)
        require'lspconfig'.tailwindcss.setup{}

        -- Lua LSP configuration to work with neovim files
        -- (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls)
        require'lspconfig'.lua_ls.setup {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            })
          end,
          settings = {
            Lua = {}
          }
        }
      end
    },

    -- autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind-nvim",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        cmp.event:on("confirm_done")

        luasnip.config.setup {}

        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        require('cmp').setup({
          snippet = {
              expand = function(args)
                -- REQUIRED - you must specify a snippet engin
                luasnip.lsp_expand(args.body)
              end,
          },
          formatting = {
            format = lspkind.cmp_format {
              with_text = true,
              menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
              },
            },
          },
          mapping = cmp.mapping.preset.insert {
            -- Mappings to nagivigate through completions
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<CR>'] = cmp.mapping.confirm { select = true },
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          },
          -- Don't auto select item
          preselect = cmp.PreselectMode.None,
          window = {
            documentation = cmp.config.window.bordered(),
          },
          view = {
            entries = {
              name = "custom",
              selection_order = "near_cursor",
            },
          },
          confirm_opts = {
            behavior = cmp.ConfirmBehavior.Insert,
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = "luasnip", keyword_length = 2},
            { name = "buffer", keyword_length = 5},
          },
        })
      end,
    },

    -- Alternate between files, such as foo.go and foo_test.go
    {
      -- Temporarily use jeanne-b fork until https://github.com/rgroli/other.nvim/pull/62 is merged
      -- "rgroli/other.nvim",
      "jeanne-b-/other.nvim",
      branch = "Fix-escape_cwd_patterns",
      config = function ()
        require("other-nvim").setup({
          -- If enabled, the window shows files that do not exist yet, based on pattern matching.
          -- Selecting a file will create it.
          showMissingFiles = false,
          -- When a mapping requires an initial selection of the other file, this setting controls
          -- wether the selection should be remembered for the current user session.
          rememberBuffers = false,
          mappings = {
            "rails",
          },
        })
      end,
    },

    -- testing framework
    {
      "vim-test/vim-test",
      config = function ()
        vim.g['test#strategy'] = 'neovim'
        vim.g['test#neovim#term_position'] = 'vert'
      end,
    },

    -- Jinja2 syntax (for Pelican)
    { "lepture/vim-jinja" }

  -- Add plugins above this line
  },

  -- Colorscheme that will be used when installing plugins. That happens before startup,
  -- so your regular color scheme would not have been loaded yet.
  install = { colorscheme = { 'habamax' } },
  -- Automatically check for plugin updates
  checker = { enabled = true },
})

----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Show line relative numbers
vim.opt.showmatch = true           -- Highlight matching parenthesis
vim.opt.splitright = true          -- Split windows right to the current windows
vim.opt.splitbelow = true          -- Split windows below to the current windows
vim.opt.autowrite = true           -- Automatically save before :next, :make etc.
-- vim.opt.autochdir = true           -- Change CWD when I open a file

vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. 'undo'

-- Indent Settings
-- I'm in the Spaces camp (sorry Tabs folks), so I'm using a combination of
-- settings to insert spaces all the time.
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current file
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Fast saving
-- vim.keymap.set('n', '<Leader>w', ':write!<CR>')
-- vim.keymap.set('n', '<Leader>q', ':q!<CR>', { silent = true })

-- Some useful quickfix shortcuts for quickfix
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>a', '<cmd>cclose<CR>')

-- Move up and down by line on the screen and not on the file
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Exit on jj and jk
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('i', 'jk', '<ESC>')

-- Remove search highlight
vim.keymap.set('n', '<Leader>n', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', {noremap = true})
vim.keymap.set('n', 'N', 'Nzzzv', {noremap = true})

-- Split navigation mappings: instead of ctrl-w then j, it’s just ctrl-j
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Buffer and windows management mappings
vim.keymap.set('n', '<leader>d', '<cmd>bp|bd #<CR>') -- Close buffer without closing split
vim.keymap.set('n', '<leader>c', '<cmd>close<CR>') -- Close the current window
vim.keymap.set('n', ']b', '<cmd>bnext<CR>') -- Go to next buffer
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>') -- Go to previous buffer

-- Builtin comments
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, desc = 'Comment with Ctrl+/ in NORMAL mode' })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, desc = 'Comment with Ctrl+/ in VISUAL mode' })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>fF', builtin.git_files, { desc = 'Search git files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search string in current directory (live grep)' })
vim.keymap.set('n', '<leader>fG', builtin.grep_string, { desc = 'Search string under cursor in current directory' })
vim.keymap.set('n', '<leader>fl', builtin.current_buffer_fuzzy_find, { desc = 'Search lines in current buffer' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search help tags' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Search symbols in current document' })
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Search symbols project-wide' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search diagnositcs' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Search nvim commands' })

-- vim-test
vim.keymap.set('n', '<leader>tt', ':TestNearest -v<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tf', ':TestFile -v<CR>', { noremap = true, silent = true })

-- other.nvim
vim.keymap.set('n', '<leader>fo', '<cmd>Other<CR>', { desc = 'Open associated files for the currently active buffer' })
vim.keymap.set('n', '<leader>ft', '<cmd>Other test<CR>', { desc = 'Open associated test file for the currently active buffer' })

-- LSP mappings
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader><leader>f', vim.lsp.buf.format, opts)

    vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})
