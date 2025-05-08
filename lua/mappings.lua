require "nvchad.mappings"
local markcycle = require("markcycle")
local reactextract = require("reactextract")
-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "ga", "<cmd>AdvancedGitSearch search_log_content_file<CR>", { desc = "Show file history log" })
map('n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap=true, silent=true })
map('n', 'gb', '<cmd>Telescope git_bcommits<CR>', { noremap=true, silent=true })
map('n', 'gc', '<cmd>Telescope git_bcommits_range<CR>', { noremap=true, silent=true })
map("n", "<Leader>g", [[:lua show_git_log_popup()<CR>]], { noremap = true, silent = true })
map("n", "gi", "<cmd>vim.lsp.buf.implementation<CR>", {desc = "Go to implementation"})
map("n", "gr", ":lua require('telescope.builtin').lsp_references()<CR>", { noremap = true, silent = true })
map("n", "g2", ":diffget 2<CR>", { desc = "Get diff from buffer 2" })
map("n", "g1", ":diffget 1<CR>", { desc = "Get diff from buffer 2" })
map('n', '<leader>c', '<cmd>lua vim.cmd("normal! f" .. vim.fn.nr2char(vim.fn.getchar()) .. "lC")<CR>', { noremap = true, silent = true })
map("n", "QQ", "<cmd>q!<CR>", { noremap=true, silent=true })
map("n", "ss", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", { noremap=true, silent=true })
map('n', '<C-g>', ':echo expand("%:p")<CR>', { noremap = true, silent = true })
map("n", "ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map("n", "fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<C-s>", "<cmd>:w<CR>", { noremap = true, desc = "Save Buffer" })
map("n", "<C-k>", "<C-y>", { noremap = true, desc = "Scroll content up" })
map("n", "<C-j>", "<C-e>", { noremap = true, desc = "Scroll content down" })
map("n", "<S-j>", "5j", { noremap = true, desc = "Scroll content up" })
map("n", "<S-k>", "5k", { noremap = true, desc = "Scroll content down" })
map("n", "<C-A-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-A-k>", "<C-w>k", { desc = "Switch window up" })


vim.keymap.set("v", "<Leader>je", reactextract.extract, { desc = "Extract JSX to new file" })

vim.keymap.set("n", "<C-M-i>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-i>", true, false, true), "n", true)
end, { desc = "Jump forward in jumplist" })



vim.keymap.set('n', '<C-A-a>', function()
  local cword = vim.fn.expand('<cword>')
  local num = tonumber(cword)
  if num then
    local new_num = num + 1
    -- Replace the current word under cursor
    vim.cmd('normal! ciw' .. new_num)
  end
end, { desc = "Increment number under cursor manually" })

-- KeymapT
vim.keymap.set('n', '<C-a>', markcycle.add_mark,   { desc = "Mark: add current file+line" })
vim.keymap.set('n', '<C-n>', markcycle.next_mark,  { desc = "Mark: jump to next global mark" })
vim.keymap.set('n', '<C-c>', markcycle.clear_marks,{ desc = "Mark: clear all marks" })

map("n", "<leader>d", function() require('telescope.builtin').diagnostics() end)
-- map("n", "<leader>e", function() vim.diagnostic.setqflist() end)
map("n", "<leader>e", "<cmd>Trouble diagnostics toggle<<CR>")
map("n", "<C-Del>", ":!rm %<CR><cmd>bdelete<CR>", {desc = "Delete file and buffer"})
map("n", "<C-Space>",vim.lsp.buf.code_action, {desc = "Complete the suggested action"} )
-- map("n", "<C-n>", "<Plug>(multiple-cursors-next)", {desc = "multicursor next"} )
-- map("n", "<leader>r", 'ciw<C-r>0<Esc>')
-- map("n", "<C-r>", 'ciw<C-r>0<Esc>')

vim.keymap.set("n", "nf", function()
  require("nvim-treesitter.textobjects.move").goto_next_start("@function.name", "textobjects")
end, { desc = "Next function name", silent = true })



-- map("i", "<C-A-j>", "<Down>", { noremap = true, desc = "Switch window down" })
-- map("i", "<C-A-k>", "<Up>", { noremap = true, desc = "Switch window up" })

-- Keymap for file history
local ags = require("telescope").extensions.advanced_git_search
vim.keymap.set("n", "<leader>gh", function()
  ags.search_log_content_file()
end, { desc = "Show file history log" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--


-- Function to open Git log popup
-- Function to open Git log popup
function show_git_log_popup()
    local filepath = vim.fn.expand('%:p')
    local filedir = vim.fn.fnamemodify(filepath, ":h")
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    local git_command = string.format("cd %s && git log --no-merges -n 1 -L %s,%s:%s",
        vim.fn.shellescape(filedir),
        vim.fn.shellescape(start_line),
        vim.fn.shellescape(end_line),
        filepath
    )

    -- Capture Git log output
    local output = vim.fn.systemlist(git_command)
    if vim.v.shell_error ~= 0 then
        print("Error running git command: " .. table.concat(output, "\n"))
        return
    end

    -- Open popup with Git log content
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'cursor',
        row = 1,
        col = 1,
        width = 80,
        height = math.min(#output, 20),
        style = 'minimal',
        border = 'rounded'
    })

     vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, 2000)

    -- Set filetype for Git syntax highlighting
    vim.api.nvim_buf_set_option(buf, 'filetype', 'git')

    -- Map <Esc> to close the popup
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<Cmd>q<CR>', { noremap = true, silent = true })
end

vim.cmd([[
  autocmd InsertLeave,TextChanged * silent! write
]])



vim.keymap.set("n", "df", function()
  local ts_utils = require("nvim-treesitter.ts_utils")

  -- Get the current function node
  local node = ts_utils.get_node_at_cursor()
  if not node then return end

  -- Climb to the function or method declaration
  while node and node:type() ~= "function_declaration" and node:type() ~= "method_declaration" do
    node = node:parent()
  end
  if not node then return end

  -- Yank the function
  local start_row, _, end_row, _ = node:range()
  vim.cmd(string.format("%d,%dy", start_row + 1, end_row + 1))

  -- Safe jump to line below pasted function (handle EOF)
  local total_lines = vim.api.nvim_buf_line_count(0)
  local target_line = math.min(end_row + 2, total_lines)
  vim.api.nvim_win_set_cursor(0, { target_line, 0 })

  -- Paste the function
  vim.cmd("put")

  -- Insert blank line after the pasted function
  local new_func_end = math.min(target_line + (end_row - start_row + 1), vim.api.nvim_buf_line_count(0))
  vim.api.nvim_buf_set_lines(0, new_func_end, new_func_end, false, { "" })

  -- Defer jump to function name so Treesitter can parse
  vim.defer_fn(function()
    require("nvim-treesitter.textobjects.move").goto_previous_start("@function.name", "textobjects")
  end, 30)
end, { desc = "Duplicate function", silent = true })






-- Create the TroubleEslint command
vim.api.nvim_create_user_command("TroubleEslint", function()
  local cmd = [[eslint_d src --ext .ts,.tsx -f unix | awk -v cwd="$PWD" '{ if ($1 ~ /^\\./) $1=cwd"/"substr($1,3); print }' > /tmp/eslint.out]]
  vim.fn.jobstart(cmd, {
    on_exit = function()
      vim.schedule(function()
        vim.cmd("cfile /tmp/eslint.out | cc | Trouble quickfix")
      end)
    end,
    stdout_buffered = true,
  })
end, {})

-- Bind <leader>ll to run the command
vim.keymap.set("n", "<leader>ll", ":TroubleEslint<CR>", { desc = "Run ESLint on src/ and show in Trouble" })

