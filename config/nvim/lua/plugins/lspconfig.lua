return {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- 'williamboman/mason.nvim',
      -- 'williamboman/mason-lspconfig.nvim',
      -- 'b0o/schemastore.nvim',
      -- { 'jose-elias-alvarez/null-ls.nvim', dependencies = 'nvim-lua/plenary.nvim' },
      -- 'jayp0521/mason-null-ls.nvim',
    },
    config = function()
      local lspconfig = require("lspconfig")

    lspconfig.gopls.setup({
      settings = {
        gopls = {
          staticcheck = true,
          gofumpt = true,
          analyses = {
            nilness = true,
            unusedwrite = true,
          },
          experimentalPostfixCompletions = false,
          hoverKind = "FullDocumentation",
          linksInHover = false,
        },
      },
    })
    
    end,
  }