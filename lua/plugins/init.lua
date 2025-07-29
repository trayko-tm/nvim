return {
-- In your lazy.nvim config file
-- tailwind-tools.lua
{
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
},{
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0,            -- How many lines the window should span. 0 = infinite
    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. 'inner' or 'outer'
    mode = 'cursor',          -- Line used to calculate context. 'cursor' or 'topline'
    separator = nil,          -- Optional separator char between context and content
    zindex = 20,              -- The Z-index of the context window
    on_attach = nil,          -- (fun(buf: integer): boolean) return false to disable attaching
  }
},




{
  "andymass/vim-matchup",
  event = "VeryLazy",
  init = function()
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_hi_surround_always = 0
    vim.g.matchup_matchparen_hi_surround = 0
    vim.g.matchup_matchparen_single = 0
  end,
  config = function()
    -- Use an autocommand to override colorscheme later
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.cmd([[
          highlight MatchParen guibg=#444444 guifg=NONE gui=NONE
          highlight MatchWord guibg=NONE guifg=NONE gui=NONE
          highlight MatchTag guibg=NONE guifg=NONE gui=NONE
        ]])
      end,
    })

    -- Immediately apply it as well
    vim.cmd([[
      highlight MatchParen guibg=#444444 guifg=NONE gui=NONE
      highlight MatchWord guibg=NONE guifg=NONE gui=NONE
      highlight MatchTag guibg=NONE guifg=NONE gui=NONE
    ]])
  end,
}
,





{
  "hrsh7th/nvim-cmp",
  lazy = false,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip", -- Snippet engine
    "dcampos/cmp-emmet-vim", -- Updated Emmet integration plugin
    "tailwind-tools",
    "onsails/lspkind-nvim"
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        {
          name = "emmet_vim",
          option = { filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "typescriptreact" } },
        },
      }, {
        { name = "buffer" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          before = require("tailwind-tools.cmp").lskind_format,
        })
      }
    })
  end,
},

{
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
},
{
  "eero-lehtinen/oklch-color-picker.nvim",
  event = "VeryLazy",
  version = "*",
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    {
      "<leader>v",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {},
},
{
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  opts = {} -- your configuration
},{
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "typescript", "typescriptreact", "jsx", "tsx" },
  config = function()
    vim.g.user_emmet_install_global = 0
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "css", "javascript", "typescript", "jsx", "tsx", "typescriptreact" },
      callback = function()
        vim.cmd("EmmetInstall")
      end,
    })
  end,
},

{
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>e",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},
{
  "nvimtools/none-ls.nvim", -- new home of null-ls
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.eslint_d.with({
          diagnostics_format = "[eslint] #{m} (#{c})",
          extra_args = {"--ext", ".ts,.tsx"},
          condition = function(utils)
            -- only run if eslint config is present
            return utils.root_has_file({"eslint.config.mjs", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs" })
          end,
        }),
        null_ls.builtins.code_actions.eslint_d, -- optional: enable eslint fixes
      },
    })
  end
},
 {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = { "AdvancedGitSearch" },
    config = function()
        -- optional: setup telescope before loading the extension
        require("telescope").setup{
            -- move this to the place where you call the telescope setup function
            extensions = {
                advanced_git_search = {
                        -- See Config
                    }
            }
        }

        require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
        --- See dependencies
    },
},  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    lazy = false,
    config = function()
      -- Optional: Add any custom Diffview settings here
      require("diffview").setup({})
    end,
  },
-- nvim v0.8.0
{
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").load_extension("lazygit")
    end,
},

{
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
{
  "github/copilot.vim",
  event = "InsertEnter", -- Lazy load on entering insert mode
},
{
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" } -- required as backend
  },
  config = function()
    require("CopilotChat").setup()
  end,
  cmd = "CopilotChat"
},

{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = false, -- Ensures it's loaded early
    },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "typescript", "javascript", "go", "html", "css", "python" },
      highlight = {
        enable = false,
        additional_vim_regex_highlighting = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["at"] = "@tag.outer",
            ["it"] = "@tag.inner",
            ["av"] = "@jsx_element.outer",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["as"] = "@statement.outer",
            ["is"] = "@statement.inner",
            ["iv"] = "@jsx_element.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]e"] = "@variable.outer",
            ["]s"] = "@statement.outer",
            ["]r"] = "@return.outer",
            ["tt"] = "@jsx.element",
            ["<S-f>"] = "@function.outer",
          },
          goto_previous_start = {
            ["[t"] = "@jsx.element",
            ["[e"] = "@variable.outer",
            ["[s"] = "@statement.outer",
          },
          goto_next_tag_end = {
            -- ["]t"] = "@tag.open_end",
          },
        },
        refactor = {
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grr",
            },
          },
        },
      },
    })
  end,
},

{"nvim-lua/plenary.nvim"},
{
  "nvim-treesitter/playground",
  cmd = "TSPlaygroundToggle",  -- lazy-load on this command
  config = function()
    vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>")
  end,
},


---@module "neominimap.config.meta"
{
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    enabled = false,
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    keys = {
        -- Global Minimap Controls
        { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
        { "<leader>no", "<cmd>Neominimap on<cr>", desc = "Enable global minimap" },
        { "<leader>nc", "<cmd>Neominimap off<cr>", desc = "Disable global minimap" },
        { "<leader>nr", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },

        -- Window-Specific Minimap Controls
        { "<leader>nwt", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
        { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
        { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
        { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },

        -- Tab-Specific Minimap Controls
        { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
        { "<leader>ntr", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },
        { "<leader>nto", "<cmd>Neominimap tabOn<cr>", desc = "Enable minimap for current tab" },
        { "<leader>ntc", "<cmd>Neominimap tabOff<cr>", desc = "Disable minimap for current tab" },

        -- Buffer-Specific Minimap Controls
        { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
        { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
        { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
        { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },

        ---Focus Controls
        { "<leader>nf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
        { "<leader>nu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
        { "<leader>ns", "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
        -- The following options are recommended when layout == "float"
        vim.opt.wrap = false
        vim.opt.sidescrolloff = 36 -- Set a large value

        --- Put your configuration here
        vim.g.neominimap = {
            auto_enable = true,
        }
    end,
},
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
-- lazy.nvim:

{
  "terryma/vim-multiple-cursors",
  -- Optionally, set a lazy-loading event or keymaps
  -- If you want to set up key mappings for the plugin, you can add a keys section:
  laz = false,
  keys = {
    { "<C-n>", "<Plug>(multiple-cursors-next)", mode = { "v" } },
    { "<C-p>", "<Plug>(multiple-cursors-prev)", mode = { "v" } },
    { "<C-q>", "<Plug>(multiple-cursors-quit)", mode = { "v" } },
  },
},{ import = "nvchad.blink.lazyspec" }
}
