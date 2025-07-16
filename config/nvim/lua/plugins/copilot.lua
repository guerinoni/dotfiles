-- Git Copilot configuration
--
return {
    "zbirenbaum/copilot.lua",
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true,

            keymap = {
                accept = '<tab>',
            },
        },

        filetypes = {
            markdown = true,
            help = true,
        },
    },
}
