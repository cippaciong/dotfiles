local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require "custom.configs.treesitter"
    end,
  },

  {
    "vim-crystal/vim-crystal",
    ft = "crystal",
    config = function()
      require "custom.configs.vim-crystal"
    end,
  },

  {
    "terrastruct/d2-vim",
    ft = "d2",
  },
}
return plugins
