return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({
        style = "night"
    })
    require('tokyonight').colorscheme()
  end,
}
