local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Color scheme
  { import = 'plugins.tokyonight' },
  { import = 'plugins.catppuccin' },
  { import = 'plugins.gruvbox' },

  -- Fuzzy finder
  { import = 'plugins.telescope' },

  -- Language Server Protocol.
  { import = 'plugins.lspconfig' },

  -- Completion
  { import = 'plugins.cmp' },

  -- Mason
  { import = 'plugins.mason' },
  { import = 'plugins.mason-lspconfig' },

  -- Copilot
  { import = 'plugins.copilot' },

  -- Show Keymaps
  { import = 'plugins.whichkey' },

  -- A Status line.
  { import = 'plugins.lualine' },

  -- Highlight variable under cursor
  { import = 'plugins.illuminate' },

  -- Better Highlighting
  { import = 'plugins.nvim-treesitter' },
})
