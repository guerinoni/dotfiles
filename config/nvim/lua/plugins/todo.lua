return {
    "folke/todo-comments.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local todo = require("todo-comments")
        todo.setup()

        vim.keymap.set("n", "<leader>td", ":TodoQuickFix<CR>")
    end
}
