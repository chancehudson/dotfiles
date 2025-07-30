-- Basic settings vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4 -- sleuth will override
-- vim.cmd.colorscheme("default")

-- Leader key
vim.g.mapleader = " "

vim.keymap.set('n', '<D-H>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<D-J>', '<C-w>j', { desc = 'Move to window below' })
vim.keymap.set('n', '<D-K>', '<C-w>k', { desc = 'Move to window above' })
vim.keymap.set('n', '<D-L>', '<C-w>l', { desc = 'Move to right window' })

-- Install lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
    end,
  },
  -- Gruvbox color theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true
  },
  -- Auto-formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          rust = { "rustfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 100,  -- Transparency
          },
        },
      })
    end,
  },
  -- gc to comment highlighted, gcc to comment current line
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
    -- Auto-detect indentation
  {
    "tpope/vim-sleuth",
  },

  -- Minimal autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      
      cmp.setup({
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        
        default_component_configs = {
          -- Add the icon configuration here
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "*",
              staged    = "+",
              conflict  = "!",
            }
          },
          diagnostics = {
            symbols = {
              hint = "󰌶",
              info = "",
              warn = "",
              error = "✖",
            },
            highlights = {
              hint = "DiagnosticSignHint",
              info = "DiagnosticSignInfo",
              warn = "DiagnosticSignWarn",
              error = "DiagnosticSignError",
            },
          },
        },
        
        window = {
          position = "left",
          width = 30,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["/"] = function (state) 
              -- Enable normal vim search in the tree
              vim.api.nvim_feedkeys("/", "n", false)
            end,
            ["n"] = function(state)
              vim.cmd("normal! n")
            end,
            ["N"] = function(state) 
              vim.cmd("normal! N")
            end,
          }
        },
        
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
              "target",
              ".git",
            },
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,  -- Auto-refresh
        },
      })
      
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
    end,
  },
  
  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").rust_analyzer.setup({
        settings = {
          ['rust-analyzer'] = {
            check = {
              allTargets = true,
              allFeatures = false,
            },
            cargo = {
              allFeatures = false,
              buildScripts = {
                enable = true,
              },
            },
          }
      }})

      -- Keybindings (after LSP attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = true })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()

      -- Keybindings
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
    end,
  },
})

