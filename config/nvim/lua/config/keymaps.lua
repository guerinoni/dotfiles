vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })

vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostics in Float" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Easy save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
