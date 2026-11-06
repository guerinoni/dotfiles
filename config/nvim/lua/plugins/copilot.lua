-- GitHub Copilot configuration
--
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true,

            keymap = {
                accept = "<tab>",
            },
        },

        filetypes = {
            markdown = true,
            help = true,

            -- Buffer contents go to GitHub, so stay out of files that hold secrets.
            env = false, -- .env, .env.local
            netrc = false, -- .netrc
            dosini = false, -- .npmrc, .pypirc
            confini = false, -- ~/.aws/credentials
            [""] = false, -- no filetype: ssh keys, .pgpass, .git-credentials
            sh = function() -- .envrc is filetype sh
                return not vim.fs.basename(vim.api.nvim_buf_get_name(0)):match("^%.env")
            end,
        },
    },
}
