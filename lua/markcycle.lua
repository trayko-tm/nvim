
-- ~/.config/nvim/lua/markcycle.lua
local M = {
  list = {},   -- holds { file = "...", line = N } entries
  idx  = 0,    -- current index into the list
}

--- Add the current buffer+line to the global mark list
function M.add_mark()
  local buf = vim.api.nvim_buf_get_name(0)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  table.insert(M.list, { file = buf, line = row })
  vim.notify(string.format("✔ Added mark: %s:%d", buf, row))
end

--- Jump to the next entry in the global mark list
function M.next_mark()
  if #M.list == 0 then
    vim.notify("⚠ No marks set", vim.log.levels.WARN)
    return
  end
  M.idx = (M.idx % #M.list) + 1
  local m = M.list[M.idx]

  if vim.api.nvim_buf_get_name(0) ~= m.file then
    vim.cmd('edit ' .. vim.fn.fnameescape(m.file))
  end
  vim.api.nvim_win_set_cursor(0, { m.line, 0 })
  vim.notify(string.format("→ %s:%d", m.file, m.line))
end

--- Clear all marks
function M.clear_marks()
  M.list = {}
  M.idx  = 0
  vim.notify("🗑 Cleared all global marks")
end

return M

