return {
  'hrsh7th/nvim-cmp',

  event = "InsertEnter",

  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },

  config = function()
    require("cmp").setup({})
  end,
}