vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.number = true             -- Enable line numbers
vim.o.relativenumber = true     -- Enable relative line numbers
vim.o.cursorline = true         -- Highlight the current line
vim.o.expandtab = true          -- Convert tabs to spaces
vim.o.shiftwidth = 4            -- Amount to indent with << and >>
vim.o.tabstop = 4               -- How many spaces are shown per Tab
vim.o.softtabstop = 4           -- How many spaces are applied when pressing Tab
vim.o.breakindent = true        -- Enable breakindent when wrapping lines
vim.o.undofile = true           -- Save undo history
vim.o.showmode = false          -- Hide mode information, it is in status line
vim.o.signcolumn = "yes"        -- Show sign column
vim.o.clipboard = "unnamedplus" -- Enable clipboard integration with system clipboard
vim.b.completion = true         -- Enable completion

-- Sets how neovim will display certain whitespace characters in the editor.
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
