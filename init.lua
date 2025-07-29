vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "


-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("NvimTreeToggle")
    end,
})


local lazy_config = require "configs.lazy"

vim.api.nvim_create_user_command(
  'StartGamePlatform',
  function()
    -- vim.cmd("NvimTreeToggle")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "i", false)
    -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n")
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
    -- local file_path = "platform/src/games.config.json"

    vim.defer_fn(function()
      local file_path = "/home/amuser/git/game-platform/platform/src/games.config.json"
      vim.cmd("edit " .. file_path)
      require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    end, 100)

    vim.defer_fn(function()
      -- Send a command to the terminal
      vim.fn.chansend(vim.b.terminal_job_id, "npx foreman start\n")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
      
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "t", false)
    end, 200)
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  'StartSingleBase',
  function()
    -- vim.cmd("NvimTreeToggle")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "i", false)
    -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n")
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
    -- local file_path = "platform/src/games.config.json"

    vim.defer_fn(function()
      local file_path = "/home/amuser/git/engines/single-base-slot/src/Main.ts"
      vim.cmd("edit " .. file_path)
      require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    end, 100)

    vim.defer_fn(function()
      -- Send a command to the terminal
      vim.fn.chansend(vim.b.terminal_job_id, "npm run debug\n")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
      
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "t", false)
    end, 200)
  end,
  { nargs = 0 }
)

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")



require "options"
require "nvchad.autocmds"


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.cmd("silent! !npx eslint --fix " .. file)
    vim.cmd("silent! !npx prettier --write " .. file)
    vim.cmd("edit")
  end,
})


vim.schedule(function()
  require "mappings"
end)

vim.opt.relativenumber=true
vim.opt.number=true
vim.opt.wrap = true
vim.opt.linebreak = true


-- Auto-hover on CursorHold

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr }) -- ✅ new recommended API

    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/hover") then
        vim.lsp.buf.hover()
        break
      end
    end
  end,
})

vim.o.updatetime = 2000  -- 500ms idle before triggering CursorHold
vim.o.winblend = 10
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" , focusable = false}
)



vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("FocusMainBufferAfterStartup", { clear = true }),
  nested = true,
  callback = function()
    -- Delay the keypress to allow NvimTree to fully open
    vim.defer_fn(function()
      -- Switch to the right window (from NvimTree to main buffer)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", false)
    end, 10)
  end,
})


vim.api.nvim_create_autocmd("User", {
  pattern = "LspJumped",
  callback = function()
    vim.cmd("lclose") 
  end,
})
