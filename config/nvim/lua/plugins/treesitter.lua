-- Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy loading
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install({
            "bash",
            "c",
            "cpp",
            "cmake",
            "dockerfile",
            "json",
            "hcl",
            "hurl",
            "go",
            "gomod",
            "gosum",
            "gotmpl",
            "gowork",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "rust",
            "sql",
            "terraform",
            "toml",
            "vim",
            "vimdoc",
            "yaml"
        })

        -- main only installs parsers, highlighting and the old incremental
        -- selection are now Neovim's job. Enter selects the node under the
        -- cursor, Enter again grows to the parent, Backspace shrinks back.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
            callback = function(args)
                if not pcall(vim.treesitter.start, args.buf) then
                    return
                end
                local select = function(target)
                    return function() vim.treesitter.select(target, vim.v.count1) end
                end
                vim.keymap.set({ "n", "x" }, "<Enter>", select("parent"), { buffer = args.buf })
                vim.keymap.set("x", "<Backspace>", select("child"), { buffer = args.buf })
            end,
        })
    end
}
