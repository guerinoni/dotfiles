-- LSP configuration
-- https://github.com/neovim/nvim-lspconfig

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Mason must be set up before its dependents
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim",    opts = {} },
        -- Registers its completion capabilities for every server on load
        "saghen/blink.cmp",
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Override the built-in grr/gri (see :help lsp-defaults) with the
                -- fzf-lua pickers. Staying on the gr prefix keeps grn, gra, grx
                -- and grt reachable, and leaves r, gi and gr themselves alone.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
                map('grr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
                map('gri', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.name == 'gopls' then
                    map("<leader>gt", "<cmd>GoTestFunc -v<CR>", "Run [Go] Test for [T]his Function")
                    map("<leader>ga", "<cmd>GoAltV<CR>", "[G]o to [A]lternate (test) file")
                end

                if
                    client and
                    client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                then
                    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd(
                        { "CursorHold", "CursorHoldI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight
                        }
                    )

                    vim.api.nvim_create_autocmd(
                        { "CursorMoved", "CursorMovedI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references
                        }
                    )

                    vim.api.nvim_create_autocmd(
                        "LspDetach",
                        {
                            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
                            end
                        }
                    )
                end

                if
                    client and
                    client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                then
                    map(
                        "<leader>th",
                        function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end,
                        "[T]oggle Inlay [H]ints"
                    )
                end
            end
        })

        vim.diagnostic.config {
            severity_sort = true,
            float = { source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            virtual_text = { source = "if_many", spacing = 2 },
        }

        local servers = {
            -- shellcheck is a linter, bashls invokes it from PATH
            bashls = {},
            marksman = {},
            dockerls = {},
            docker_compose_language_service = {},
            jsonls = {},
            clangd = {},
            terraformls = {},
            yamlls = {},

            gopls = {
                settings = {
                    gopls = {
                        -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = { "-.git" },
                        semanticTokens = true,

                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true
                        },
                        analyses = {
                            -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
                            unusedvariable = true,
                            shadow = true,
                            -- fieldalignment is noisy on existing codebases
                            -- and the wins are negligible outside hot paths.
                            fieldalignment = false,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true
                        }
                    }
                }
            },

            taplo = {},
            lua_ls = {},
        }

        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(
            ensure_installed,
            {
                "shellcheck",   -- Bash linter (invoked by bashls)
                "shfmt",        -- Bash formatter
                "stylua",       -- Lua formatter
                "clang-format", -- C/C++ formatter
                "jq",           -- JSON formatter
                "yamlfmt"       -- YAML formatter
            }
        )
        require("mason-tool-installer").setup { ensure_installed = ensure_installed }

        -- Register per-server config with vim.lsp.config so the settings
        -- actually reach the server. mason-lspconfig 2.x removed the
        -- `handlers` field, and automatic_enable (default true) takes care
        -- of vim.lsp.enable() once the server is installed.
        for name, config in pairs(servers) do
            vim.lsp.config(name, config)
        end

        require("mason-lspconfig").setup {
            ensure_installed = {}, -- mason-tool-installer handles installs
        }

        -- rust-analyzer is managed by rustaceanvim, see plugins/rustaceanvim.lua
    end
}
