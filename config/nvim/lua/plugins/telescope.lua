return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>f', function() require('telescope.builtin').git_files() end },
      { '<leader>F', function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' }) end },
      { '<leader>b', function() require('telescope.builtin').buffers() end },
      { '<leader>g', function() require('telescope').extensions.live_grep_args.live_grep_args() end },
      { '<leader>h', function() require('telescope.builtin').oldfiles() end },
      { '<leader>s', function() require('telescope.builtin').lsp_document_symbols() end },
    },
    config = function ()
      require('telescope')
    end,
  }