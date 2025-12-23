-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable', -- latest stable release
    lazyrepo,
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current file
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

---------------
--- PLUGINS ---
---------------
-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- Colorscheme
    {
      "nordtheme/vim",
      lazy = false,    -- make sure we load this during startup if it is your main colorscheme
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
      opts = {
        options = {
          theme = 'nord',
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_b = {},
          lualine_c = {
            {
              'buffers',
              show_filename_only = false,
            }
          },
          lualine_x = {},
        },
        inactive_sections = {
          lualine_c = {},
          lualine_x = {}
        }
      }
    },

    -- Highlight, edit, and navigate code
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ":TSUpdate", -- automatically update installed parses on plugin upgrades
      config = function()
        require 'nvim-treesitter'.install {
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
        }
      end,
    },

    -- Fuzzy finder
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      ---@module "fzf-lua"
      ---@type fzf-lua.Config|{}
      ---@diagnostics disable: missing-fields
      opts = {},
      ---@diagnostics enable: missing-fields
      config = function()
        require('fzf-lua').setup({
          actions = {
            files = {
              ["enter"] = FzfLua.actions.file_edit,
            }
          }
        })

        vim.api.nvim_set_keymap("n", "<leader>fg", [[<Cmd>lua require"fzf-lua".global()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>ff", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fF", [[<Cmd>lua require"fzf-lua".git_files()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fa", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fA", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fb", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fB", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<leader>fe", [[<Cmd>lua require"fzf-lua".diagnostics_document()<CR>]], {})
        vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})
      end
    },

    -- LSP package manager
    {
      "williamboman/mason.nvim",
      lazy = false,
      config = true
    },

    {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      opts = {
        ensure_installed = {
          "emmet_language_server",
          "lua_ls",
          "rubocop",
          "ruby_lsp",
          "tailwindcss",
        },
      },
    },

    -- Community-defined LSP settings and custom overrides
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- Ruby (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruby_lsp)
        vim.lsp.config('ruby_lsp', { capabilities = capabilities })
        vim.lsp.enable('ruby_lsp')

        -- Emmet (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#emmet_language_server)
        vim.lsp.enable('emmet_language_server')

        -- TailwindCSS (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss)
        vim.lsp.enable('tailwindcss')

        -- Lua LSP configuration to work with neovim files
        -- (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls)
        vim.lsp.config('lua_ls', {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
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
        })

        -- LSP mappings
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
        vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
        vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, {})
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
        vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, {})
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {})
      end,
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
            { name = "luasnip", keyword_length = 2 },
            { name = "buffer",  keyword_length = 5 },
          },
        })
      end,
    },

    -- Alternate between files, such as foo.go and foo_test.go
    {
      "rgroli/other.nvim",
      config = function()
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

        -- other.nvim mappings
        vim.keymap.set('n', '<leader>oo', '<cmd>Other<CR>',
          { desc = 'Open associated files for the currently active buffer' })
        vim.keymap.set('n', '<leader>ot', '<cmd>Other test<CR>',
          { desc = 'Open associated test file for the currently active buffer' })
      end,
    },

    -- testing framework
    {
      "vim-test/vim-test",
      config = function()
        vim.g['test#strategy'] = 'neovim'
        vim.g['test#neovim#term_position'] = 'vert'

        -- vim-test mappings
        vim.keymap.set('n', '<leader>tt', ':TestNearest -v<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>tf', ':TestFile -v<CR>', { noremap = true, silent = true })
      end,
    },

    -- Jinja2 syntax (for Pelican)
    { "lepture/vim-jinja" },

    -- Ruby/Rails minitest
    { "sunaku/vim-ruby-minitest" },

    -- Markdown live preview
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },

    -- Add plugins above this line
  },
})

----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable showmode because we have lauline.nvim
vim.opt.showmode = false

vim.opt.termguicolors = true  -- Enable 24-bit RGB colors

vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show line relative numbers
vim.opt.showmatch = true      -- Highlight matching parenthesis
vim.opt.splitright = true     -- Split windows right to the current windows
vim.opt.splitbelow = true     -- Split windows below to the current windows
vim.opt.autowrite = true      -- Automatically save before :next, :make etc.
-- vim.opt.autochdir = true           -- Change CWD when I open a file

vim.opt.mouse = 'a'                               -- Enable mouse support
vim.opt.swapfile = false                          -- Don't use swapfile
vim.opt.ignorecase = true                         -- Search case insensitive...
vim.opt.smartcase = true                          -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

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

-- Some useful quickfix shortcuts for quickfix
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zz')

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
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- Split navigation mappings: instead of ctrl-w then j, it’s just ctrl-j
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Buffer and windows management mappings
vim.keymap.set('n', '<leader>d', '<cmd>bp|bd #<CR>') -- Close buffer without closing split
vim.keymap.set('n', '<leader>c', '<cmd>close<CR>')   -- Close the current window
vim.keymap.set('n', ']b', '<cmd>bnext<CR>')          -- Go to next buffer
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>')      -- Go to previous buffer

-- Builtin comments
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, desc = 'Comment with Ctrl+/ in NORMAL mode' })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, desc = 'Comment with Ctrl+/ in VISUAL mode' })

-- Show diagnostics under cursor in a floating window (use <C-w>w or <C-w><C-w> to switch focus to it)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- Show diagnostics automatically in a floating window on cursor hold
vim.opt.updatetime = 2000 --  set updatetime to 2000 milliseconds (2 seconds) for faster diagnostics
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end
})

-- Custom diagnostic signs
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
})

-- Your custom highlight groups for colors
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = '#808080', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = '#808080', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = '#808080', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = '#808080', italic = true })

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#2a2a2a' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#2a2a2a', fg = '#565656' })
