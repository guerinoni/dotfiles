return {
  'neovim/nvim-lspconfig',

  config = function()
    local lspconfig = require("lspconfig")
    local telescope = require("telescope.builtin")

    lspconfig.gopls.setup({
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
    })  

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
        vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
        vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'ff', function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      
      end,
    })
  end
}
