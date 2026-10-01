return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },

    opts = {
        -- gopls is configured once, in plugins/lsp.lua
        lsp_cfg = false,
        lsp_keymaps = false, -- Disable go.nvim keymaps to prevent conflicts
    },

    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    build = ':lua require("go.install").update_all_sync()', -- Install/update all binaries
}
