return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                bash = { "shfmt", "shellcheck" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                lua = { "stylua" },
                rust = { "rustfmt" },
                go = { "gofmt" },            -- gopls can format too, but gofmt is safe standalone
                dockerfile = { "dockfmt" },  -- or use "dockerfile_lint" if installed
                json = { "jq", "jsonlint" }, -- jq formats, jsonlint can validate
                terraform = { "terraform_fmt", "tflint" },
                yaml = { "yamlfmt", "yamllint" },
                sh = { "shfmt", "shellcheck" },
            },

            -- Optional: fallback to LSP formatter if no formatter found
            format_on_save = false, -- Set to true to enable auto-format on save
            lsp_fallback = true,
        })

        -- Custom ":Format" command
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, #end_line },
                }
            end

            conform.format({
                async = true,
                lsp_fallback = true,
                range = range,
            })
        end, { range = true, desc = "Format current buffer or selected range" })
    end,
}
