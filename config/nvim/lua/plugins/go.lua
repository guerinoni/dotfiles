return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/neotest",
        "nvim-neotest/neotest-go",
    },
    
    opts = {
        lsp_cfg = true,
        lsp_keymaps = false, -- Disable go.nvim keymaps to prevent conflicts
        lsp_inlay_hints = {
            enabled = true,
            prefix = ' ',
            highlight = 'Comment',
            priority = 100,
        },
    },

    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    build = ':lua require("go.install").update_all_sync()', -- Install/update all binaries
}
