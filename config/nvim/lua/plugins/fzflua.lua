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
            "<leader>fd",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "[F]ind [D]iagnostics",
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
    }
}
