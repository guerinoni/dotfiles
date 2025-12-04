vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Easy save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })

-- Quickfix list for all diagnostics (LSP-wide, not just file)
vim.keymap.set('n', '<leader>do', function()
  vim.diagnostic.setqflist()
  vim.cmd('copen')
end, { desc = "Open quickfix list with all diagnostics" })

vim.keymap.set('n', '<leader>dc', function()
  vim.cmd('cclose')
end, { desc = "Close quickfix list" })

-- Telescope workspace diagnostics (if you have telescope.nvim)
vim.keymap.set('n', '<leader>dw', function()
  require('telescope.builtin').diagnostics({ bufnr = nil })
end, { desc = "Workspace diagnostics (Telescope)" })
