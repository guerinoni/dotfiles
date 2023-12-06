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

  -- Fuzzy finder
  { import = 'plugins.telescope' },

  -- Language Server Protocol.
  { import = 'plugins.lspconfig' },

  -- Completion
  { import = 'plugins.cmp' },

  -- Mason
  { import = 'plugins.mason' },
})
