-- File exmplorer
--
return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        -- Show hidden files by default
        view_options = {
            show_hidden = true,
        },
        -- Optional: Add keymaps for toggling hidden files
        keymaps = {
            ["g."] = "actions.toggle_hidden",
        },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
}
