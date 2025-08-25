return {
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = function()
            require('blame').setup {}
            vim.keymap.set('n', '<leader>gb', '<cmd>BlameToggle<CR>', { desc = 'Toggle Git Blame' })
        end,
    },
}
