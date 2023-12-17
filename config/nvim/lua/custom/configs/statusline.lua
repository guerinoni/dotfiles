local fn = vim.fn

local modes = {
	["n"] = { "NORMAL", "St_NormalMode" },
	["no"] = { "NORMAL (no)", "St_NormalMode" },
	["nov"] = { "NORMAL (nov)", "St_NormalMode" },
	["noV"] = { "NORMAL (noV)", "St_NormalMode" },
	["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
	["niI"] = { "NORMAL i", "St_NormalMode" },
	["niR"] = { "NORMAL r", "St_NormalMode" },
	["niV"] = { "NORMAL v", "St_NormalMode" },
	["nt"] = { "NTERMINAL", "St_NTerminalMode" },
	["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

	["v"] = { "VISUAL", "St_VisualMode" },
	["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
	["V"] = { "V-LINE", "St_VisualMode" },
	["Vs"] = { "V-LINE", "St_VisualMode" },
	[""] = { "V-BLOCK", "St_VisualMode" },

	["i"] = { "INSERT", "St_InsertMode" },
	["ic"] = { "INSERT (completion)", "St_InsertMode" },
	["ix"] = { "INSERT completion", "St_InsertMode" },

	["t"] = { "TERMINAL", "St_TerminalMode" },

	["R"] = { "REPLACE", "St_ReplaceMode" },
	["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
	["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
	["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
	["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
	["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

	["s"] = { "SELECT", "St_SelectMode" },
	["S"] = { "S-LINE", "St_SelectMode" },
	[""] = { "S-BLOCK", "St_SelectMode" },
	["c"] = { "COMMAND", "St_CommandMode" },
	["cv"] = { "COMMAND", "St_CommandMode" },
	["ce"] = { "COMMAND", "St_CommandMode" },
	["r"] = { "PROMPT", "St_ConfirmMode" },
	["rm"] = { "MORE", "St_ConfirmMode" },
	["r?"] = { "CONFIRM", "St_ConfirmMode" },
	["x"] = { "CONFIRM", "St_ConfirmMode" },
	["!"] = { "SHELL", "St_TerminalMode" },
}

return {
	mode = function()
		local m = vim.api.nvim_get_mode().mode
		local current_mode = "%#" .. modes[m][2] .. "#" .. " " .. modes[m][1] .. " "
		local mode_sep1 = "%#" .. modes[m][2] .. "Sep" .. "#"

		return current_mode .. mode_sep1
	end,
	fileInfo = function()
		local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:~:.")
		return "%#St_file_info#" .. " " .. filename .. " " .. "%#St_file_sep#"
	end,
	git = function()
		if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
			return ""
		end

		local git_status = vim.b.gitsigns_status_dict

		local added = (git_status.added and git_status.added ~= 0) and (" +" .. git_status.added) or ""
		local changed = (git_status.changed and git_status.changed ~= 0) and (" ~" .. git_status.changed) or ""
		local removed = (git_status.removed and git_status.removed ~= 0) and (" -" .. git_status.removed) or ""
		local branch_name = " " .. git_status.head .. " "

		return "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
	end,
	cwd = function()
		local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t")
		return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. dir_name)) or ""
	end,
	cursor_position = function()
		local current_line = fn.line(".")
		local current_column = fn.col(".")
		return "%#St_pos_text#" .. " " .. current_line .. ":" .. current_column .. " "
	end,
	LSP_Diagnostics = function()
		if not rawget(vim, "lsp") then
			return ""
		end

		local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

		local serrors = (errors and errors > 0) and ("%#St_lspError#" .. errors .. " ") or ""
		local swarnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. warnings .. " ") or ""
		local shints = (hints and hints > 0) and ("%#St_lspHints#" .. hints .. " ") or ""
		local sinfo = (info and info > 0) and ("%#St_lspInfo#" .. info .. " ") or ""

		return serrors .. swarnings .. shints .. sinfo
	end,
	LSP_status = function()
		if rawget(vim, "lsp") then
			for _, client in ipairs(vim.lsp.get_active_clients()) do
				if
					client.attached_buffers[vim.api.nvim_get_current_buf()]
					and client.name ~= "null-ls"
					and client.name ~= "copilot"
				then
					return (vim.o.columns > 100 and "%#St_LspStatus#" .. client.name .. " ") or ""
				end
			end
		end
	end,
	LSP_progress = function()
		if not rawget(vim, "lsp") or vim.lsp.status then
			return ""
		end

		local Lsp = vim.lsp.util.get_progress_messages()[1]

		if vim.o.columns < 120 or not Lsp then
			return ""
		end

		if Lsp.done then
			vim.defer_fn(function()
				vim.cmd.redrawstatus()
			end, 1000)
		end

		local msg = Lsp.message or ""
		local title = Lsp.title or ""
		local content = string.format(" %%<%s %s ", title, msg)

		return ("%#St_LspProgress#" .. content) or ""
	end,
}
