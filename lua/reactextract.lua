local reactextract = {}

local function get_visual_selection()
  vim.cmd("normal! gv") -- reselect visual area to get correct range
  local mode = vim.fn.visualmode()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

  -- Only trim columns in character mode
  if mode == "v" and #lines > 0 then
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  return lines, start_pos, end_pos
end

function reactextract.extract()
  local jsx_lines, start_pos, end_pos = get_visual_selection()
  if #jsx_lines == 0 then
    print("No JSX selected")
    return
  end

  local input_path = vim.fn.input("Save to (e.g. @/components/MyCard.tsx or ./MyCard.tsx): ")
  if input_path == nil or input_path == "" then
    print("Cancelled")
    return
  end

  local project_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.loop.cwd()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  local resolved_path = input_path
  local import_path = input_path:gsub("%.tsx$", "")

  if vim.startswith(input_path, "@/") then
    resolved_path = project_root .. "/src/" .. input_path:sub(3)
    import_path = input_path:gsub("%.tsx$", "")
  elseif vim.startswith(input_path, "./") then
    resolved_path = current_dir .. "/" .. input_path:sub(3)
    import_path = "./" .. input_path:sub(3):gsub("%.tsx$", "")
  else
    resolved_path = current_dir .. "/" .. input_path
    import_path = "./" .. input_path:gsub("%.tsx$", "")
  end

  local component_name = resolved_path:match("([^/\\]+)%.tsx$") or "Component"
  local component_dir = resolved_path:match("(.+)/[^/]+%.tsx$") or "."

  local component_lines = {
    "import React from 'react';",
    "",
    "export const " .. component_name .. " = (props) => {",
    "  return ("
  }

  for _, line in ipairs(jsx_lines) do
    table.insert(component_lines, "    " .. line)
  end

  table.insert(component_lines, "  );")
  table.insert(component_lines, "};")
  table.insert(component_lines, "")

  vim.fn.mkdir(component_dir, "p")
  vim.fn.writefile(component_lines, resolved_path)
  print("✅ Extracted to " .. resolved_path)

  vim.api.nvim_buf_set_lines(0, 0, 0, false, {
    "import { " .. component_name .. " } from '" .. import_path .. "';"
  })

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]
  vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, {
    "<" .. component_name .. " />"
  })
end

return reactextract
