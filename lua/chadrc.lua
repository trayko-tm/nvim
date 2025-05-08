-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@class M : ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.ui = {
    statusline = {
        theme = "default", -- default/vscode/vscode_colored/minimal
        separator_style = "default",
        modules= {
            cursor = function()
                local buf = vim.api.nvim_get_current_buf()
                local current_line = vim.fn.line(".")
                local total_lines = vim.api.nvim_buf_line_count(buf)
                return string.format(" %d/%d ", current_line, total_lines)
            end,
        }

    },
}


return M
