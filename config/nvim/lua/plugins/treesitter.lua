-- Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "dockerfile",
                "json",
                "hcl",
                "hurl",
                "go",
                "gomod",
                "gosum",
                "gotmpl",
                "gowork",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "rust",
                "sql",
                "terraform",
                "toml",
                "vim",
                "vimdoc",
                "yaml"
            },

            highlight = { enable = true },

            -- Hitting enter select the word, next <enter> select entire block, next <enter> select entire
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>",
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })
    end
}
