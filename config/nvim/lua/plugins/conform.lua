return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            -- Linters (shellcheck, jsonlint, tflint, yamllint) intentionally
            -- not here: conform runs formatters and the linters' output would
            -- get treated as buffer content. shellcheck is wired through
            -- bashls; yaml/json/terraform diagnostics come from their LSPs.
            formatters_by_ft = {
                bash      = { "shfmt" },
                sh        = { "shfmt" },
                c         = { "clang-format" },
                cpp       = { "clang-format" },
                lua       = { "stylua" },
                rust      = { "rustfmt" },
                go        = { "goimports" },
                json      = { "jq" },
                terraform = { "terraform_fmt" },
                yaml      = { "yamlfmt" },
            },

            format_on_save = false,
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
