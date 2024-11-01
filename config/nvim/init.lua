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

    -- Comment
    {
      "numToStr/Comment.nvim",
      opts = {
        -- LHS of toggle mappings in NORMAL mode
        toggler = {
          -- Line-comment toggle keymap
          line = '<leader>cc',
          -- Block-comment toggle keymap
          block = '<leader>bc',
        },
        -- LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>cc',
            ---Block-comment keymap
            block = '<leader>bc',
        },
      }
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
vim.keymap.set('n', '<Leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', {noremap = true})
vim.keymap.set('n', 'N', 'Nzzzv', {noremap = true})

-- Split navigation mappings: instead of ctrl-w then j, it’s just ctrl-j
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
