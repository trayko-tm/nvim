-- load defaults i.e lua_lsp
local nvlps = require("nvchad.configs.lspconfig").defaults()
local util = require("lspconfig/util");

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" , "ts_ls", "jdtls", "kotlin_language_server", "gopls", "tailwindcss", "markdown_oxide", "emmet_ls", "cssls", "pyright"}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

local backend_dir = vim.fn.getcwd() .. "/backend"
local site_packages = backend_dir .. "/.venv/lib/python3.12/site-packages"

lspconfig.pyright.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_dir = util.root_pattern(".git", ".venv", "pyproject.toml")(backend_dir),
  settings = {
    python = {
      pythonPath = "/Users/traykotraykov/.local/share/uv/python/cpython-3.12.10-macos-aarch64-none/bin/python3.12",
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        extraPaths = { backend_dir, site_packages },
      },
    },
  },
})
-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
