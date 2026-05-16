return {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false, -- This plugin is already lazy

    -- Settings must live on vim.g.rustaceanvim and be set BEFORE the plugin
    -- loads its ftplugin/rust.lua. `init` runs before the plugin sources;
    -- `config` would be too late.
    init = function()
        vim.g.rustaceanvim = {
            tools = {
                code_actions = {
                    ui_select_fallback = true,
                },
            },
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        assist = {
                            importGranularity = "crate",
                            importEnforceGranularity = true,
                        },
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                        -- New schema: checkOnSave is a boolean; the check
                        -- command moves to its own `check` block.
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                            extraArgs = { "--all-features" },
                        },
                        completion = {
                            autoimport = { enable = true },
                            postfix = { enable = true },
                        },
                        inlayHints = {
                            typeHints = { enable = true },
                            chainingHints = { enable = true },
                            bindingModeHints = { enable = true },
                            closureReturnTypeHints = { enable = "always" },
                            lifetimeElisionHints = { enable = "always" },
                            maxLength = 5,
                            enable = true,
                        },
                        lens = { enable = true },
                    },
                },
                on_attach = function(_, bufnr)
                    require("which-key").add({
                        { "<leader>r",  group = "Rust" },
                        { "<leader>rr", ":RustLsp runnables<CR>",        desc = "Runnables" },
                        { "<leader>rp", ":RustLsp parentModule<CR>",     desc = "Parent module" },
                        { "<leader>rm", ":RustLsp expandMacro<CR>",      desc = "Expand macro" },
                        { "<leader>rc", ":RustLsp openCargo<CR>",        desc = "Open crate" },
                        { "<leader>rg", ":RustLsp crateGraph x11<CR>",   desc = "Crate graph" },
                        { "<leader>rd", ":RustLsp debuggables<CR>",      desc = "Debuggables" },
                    }, { noremap = true, silent = true, buffer = bufnr })
                end,
            },
        }
    end,
}
