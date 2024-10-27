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
-- vim.opt.clipboard = 'unnamedplus'  -- Copy/paste to system clipboard
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
