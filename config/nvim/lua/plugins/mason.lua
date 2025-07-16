return {
    "williamboman/mason.nvim",
    build = ":MasonInstallAll",
    config = function()
        require("mason").setup(
            {
                ui = {
                    border = "shadow",
                    zindex = 99
                }
            }
        )

        vim.api.nvim_create_user_command(
            "MasonInstallAll",
            function()
                vim.cmd("MasonUpdate")
                local ensure_installed = {
                    "bash-language-server",
                    "clang-format",
                    "clangd",
                    "dockerfile-language-server",
                    "gopls",
                    "jq",
                    "json-lsp",
                    "jsonlint",
                    "lua-language-server",
                    "rust-analyzer",
                    "shellcheck",
                    "shfmt",
                    "stylua",
                    "terraform-ls",
                    "tflint",
                    "yaml-language-server",
                    "yamlfmt",
                    "yamllint"
                }
                vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
            end,
            { desc = "install all lsp tools" }
        )
    end
}
