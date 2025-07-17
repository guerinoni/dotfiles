-- Autocomplete
-- https://github.com/saghen/blink.cmp

return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "zbirenbaum/copilot.lua",
    },

    opts = {
        signature = { enabled = true, window = { border = "single" } },
        fuzzy = { implementation = "prefer_rust_with_warning" },

        keymap = {
            preset = 'default',
            ['<enter>'] = { 'accept', 'fallback' }
        },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 0 },
            ghost_text = { enabled = true }
        },

        sources = {
            default = { 'lsp', 'buffer', 'snippets', 'path' },
            providers = {},
        },
    }
}
