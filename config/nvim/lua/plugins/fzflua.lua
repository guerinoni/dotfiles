return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
        files = {
            -- Include hidden files in search
            fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
            rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules'",
        },
        grep = {
            -- Add --fixed-strings option to treat input as literal strings
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --fixed-strings -g '!.git' -g '!node_modules'",
        },
        live_grep = {
            -- Add --fixed-strings option for live grep as well
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --fixed-strings -g '!.git' -g '!node_modules'",
        },
        lsp = {
            -- Jump directly if only one result (skips the picker)
            jump1 = true,
            -- Don't include the declaration in references
            includeDeclaration = false,
        },
    },
    keys = {
        {
            "<leader>ff",
            function() 
                require('fzf-lua').files({
                    cmd = "rg --files --hidden --follow -g '!.git' -g '!node_modules'"
                })
            end,
            desc = "Find Files in project directory (including hidden)"
        },
        {
            "<leader>fg",
            function() require('fzf-lua').live_grep() end,
            desc = "Find by grepping in project directory"
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "[F]ind [H]elp",
        },
        {
            "<leader>fk",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "[F]ind [K]eymaps",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").builtin()
            end,
            desc = "[F]ind [B]uiltin FZF",
        },
        {
            "<leader>fw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[F]ind current [W]ord",
        },
        {
            "<leader>fW",
            function()
                require("fzf-lua").grep_cWORD()
            end,
            desc = "[F]ind current [W]ORD",
        },
        {
            "<leader>fs",
            function()
                require("fzf-lua").lsp_document_symbols()
            end,
            desc = "[F]ind [S]ymbols (functions, classes, etc.)",
        },
        {
            "<leader>fd",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "[F]ind [D]iagnostics (buffer)",
        },
        {
            "<leader>fD",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            desc = "[F]ind [D]iagnostics (workspace)",
        },
        {
            "<leader>fr",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[F]ind [R]esume",
        },
        {
            "<leader>fo",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "[F]ind [O]ld Files",
        },
        {
            "<leader><leader>",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[,] Find existing buffers",
        },
        {
            "<leader>/",
            function()
                require("fzf-lua").lgrep_curbuf()
            end,
            desc = "[/] Live grep the current buffer",
        },
        {
            "<leader>gs",
            function()
                require("fzf-lua").git_status()
            end,
            desc = "[G]it [S]tatus (changed files, switch over them)",
        },
        {
            "<leader>gg",
            function()
                -- Restrict live grep to files changed vs HEAD (tracked + untracked).
                local files = vim.fn.systemlist(
                    "git diff --name-only HEAD; git ls-files --others --exclude-standard"
                )
                if vim.v.shell_error ~= 0 or #files == 0 then
                    vim.notify("No changed files", vim.log.levels.INFO)
                    return
                end
                require("fzf-lua").live_grep({ search_paths = files })
            end,
            desc = "[G]it changed files: live [G]rep",
        },
    }
}
