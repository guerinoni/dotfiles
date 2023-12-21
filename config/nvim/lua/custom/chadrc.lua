---@type ChadrcConfig
local M = {}
local customStatusline = require("custom.configs.statusline")

M.ui = {
	theme = "tokyonight",
	theme_toggle = { "gruvbox", "one_light" },
	transparency = true,
	statusline = {
		separator_style = "block",
		overriden_modules = function(modules)
			modules[1] = customStatusline.mode()
			modules[2] = customStatusline.fileInfo()
			modules[3] = customStatusline.git()

			modules[5] = customStatusline.LSP_progress()

			modules[7] = customStatusline.LSP_Diagnostics()
			modules[8] = customStatusline.LSP_status()
			modules[9] = customStatusline.cwd()
			modules[10] = customStatusline.cursor_position()
		end,
	},
	tabufline = {
		overriden_modules = function(modules)
			modules[4] = ""
		end,
	},
}

M.plugins = "custom.plugins"

return M
