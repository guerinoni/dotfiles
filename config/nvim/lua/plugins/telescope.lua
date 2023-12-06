return {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
  
  event = "VeryLazy",
  
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  
  keys = {
    { '<leader>f', function() require('telescope.builtin').git_files() end },
    { '<leader>F', function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' }) end },
    { '<leader>g', function() require('telescope.builtin').live_grep() end },
    { '<leader>h', function() require('telescope.builtin').oldfiles() end },
  },
  
  config = function ()
    require('telescope')
  end,
}
