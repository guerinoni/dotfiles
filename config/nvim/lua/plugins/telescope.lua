return {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
  
  event = "VeryLazy",
  
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  
  keys = {
    { '<leader>f', function() require('telescope.builtin').git_files() end },
    { '<leader>F', function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' }) end },
    { '<leader>g', function() require('telescope').extensions.live_grep_args.live_grep_args() end },
    { '<leader>h', function() require('telescope.builtin').oldfiles() end },
  },
  
  config = function ()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '  ',
        layout_config = {
          prompt_position = 'top',
        },
        preview = {
          timeout = 200,
        },
        sorting_strategy = 'ascending',
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,
          },
        },
        file_ignore_patterns = { '.git/' },
      },
      extensions = {
        live_grep_args = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          previewer = true,
        },
        buffers = {
          previewer = true,
          layout_config = {
            width = 80,
          },
        },
        oldfiles = {
          prompt_title = 'History',
        },
        lsp_references = {
          previewer = true,
        },
        lsp_definitions = {
          previewer = true,
        },
        lsp_document_symbols = {
          symbol_width = 55,
        },
      },
    })
  end,
}
