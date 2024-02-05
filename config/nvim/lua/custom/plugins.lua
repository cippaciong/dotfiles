local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function ()
      return require "custom.configs.treesitter"
    end,
  },
}
return plugins
