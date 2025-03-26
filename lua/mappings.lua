require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "ga", "<cmd>AdvancedGitSearch search_log_content_file<CR>", { desc = "Show file history log" })
map('n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap=true, silent=true })
map('n', 'gb', '<cmd>Telescope git_bcommits<CR>', { noremap=true, silent=true })
map('n', 'gc', '<cmd>Telescope git_bcommits_range<CR>', { noremap=true, silent=true })
map("n", "<Leader>g", [[:lua show_git_log_popup()<CR>]], { noremap = true, silent = true })
map("n", "gi", "<cmd>vim.lsp.buf.implementation", {desc = "Go to implementation"})
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
local harpoon = require("harpoon")
map("n", "<leader>h", function() harpoon:list():clear() end)
map("n", "<leader>d", function() require('telescope.builtin').diagnostics() end)
map("n", "<leader>e", function() vim.diagnostic.setqflist() end)
map("n", "<C-Del>", ":!rm %<CR><cmd>bdelete<CR>", {desc = "Delete file and buffer"})
map("n", "<C-Space>",vim.lsp.buf.code_action, {desc = "Complete the suggested action"} )

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

