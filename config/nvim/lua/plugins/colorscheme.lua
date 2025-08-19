return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000, -- Make sure it loads before other UI plugins
    config = function()
        vim.cmd("colorscheme nordfox")
    end
}
