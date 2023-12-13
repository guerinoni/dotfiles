local opts = {
	ensure_installed = {
		"bashls",
		"lua_ls",
		"jsonls",
		"clangd",
    "gopls",
    "rust_analyzer",
	},

	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
