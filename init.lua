----
-- Plugin Manager
----
-- https://lazy.folke.io/installation

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo(
    {
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    },
    true,
    {})

    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--vim.g.coq_settings.completion.skip_after = {"", "<tab>", "[", "]", "{", "}"}
--table.insert(vim.g.coq_settings, "completion")
--table.insert(vim.g.coq_settings.completion, "skip_after")
--vim.g.coq_settings.insertcompletion.skip_after = {""}

--skip_after = {""}

-- Setup lazy.nvim
require("lazy").setup({
  -- LSP
  spec = {
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = {
        -- main one
        {
          "ms-jpq/coq_nvim",
          --build = function()
            --  vim.fn["COQdeps"]
            --end,
            lazy = false,
            branch = "coq",
            init = function()
              vim.g.coq_settings = {
                ["auto_start"] = "shut-up",
                ["completion"] = {
                  ["skip_after"] = {
                    " ", "[", "]", "{", "}"
                  }
                }
              }
            end
          },

          -- 9000+ Snippets
          { "ms-jpq/coq.artifacts", branch = "artifacts" },

          -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
          -- Need to **configure separately**
          { 'ms-jpq/coq.thirdparty', branch = "3p" }
          -- - shell repl
          -- - nvim lua api
          -- - scientific calculator
          -- - comment banner
          -- - etc
      },
      init = function()
        vim.g.coq_settings = {
          auto_start = "shut-up", -- if you want to start COQ at startup
          -- Your COQ settings here
        }
      end,
      config = function()
        do
          local lsp_list = {
            ['vhdl']            = 'vhdl_ls',
            ['systemverilog']   = 'verible',
            ['verilog']         = 'verible',
            ['tex']             = 'texlab',
            ['c']               = 'clangd',
            ['cpp']             = 'clangd',
            ['python']          = 'pyright',
            ['markdown']        = 'marksman'
          }

          local ft, _ = vim.filetype.match({buf = vim.api.nvim_get_current_buf()})
          local lsp = lsp_list[ft]

          if lsp then
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local settings = function(lsp)
              local lsp_setting = {
                --['ltex'] = { ltex = { language = "fr" } },
                --['ghdl_ls'] = { vhdl = { debugLSP = true } },
              }
              local configs = require('lspconfig.configs')

              if lsp_setting[lsp] then
                return lsp_setting[lsp]
              elseif configs.lsp then
                return configs.lsp.default_config.settings
              else
                return {}
              end
            end

            require("lspconfig")[lsp].setup(
            require("coq").lsp_ensure_capabilities({
              capabilities = capabilities,
              settings = settings(lsp),
              on_attach = lsp_attach,
            }))
          end
        end
      end
    },

    --{
    --  'nvim-treesitter/nvim-treesitter',
    --  lazy = false,
    --  opts = {
    --    ensure_installed = {"c", "vhdl", "verilog", "systemverilog", "markdown", "lua", "tcl"},
    --    sync_install = true,
    --    auto_install = true,
    --      indent = { enable = true},
    --    highlight = { enable = true },
    --  }
    --},

    --{
    --  'stevearc/conform.nvim',
    --  opts = {},
    --},

    --{
    --    "lukas-reineke/indent-blankline.nvim",
    --    main = "ibl",
    --    ---@module "ibl"
    --    ---@type ibl.config
    --    opts = {},
    --},

    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- LaTeX
    {
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end
    },

    -- Markdown
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Debugger adapter protocol
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
      }
    },

    -- Directory
    {
      "ms-jpq/chadtree",
      branch = "chad",
      --build = function() vim.fn["CHADdeps"] end,
      init = function()
        vim.keymap.set("n", "<leader>f", "<cmd>CHADopen<cr>", {noremap = true, silent = true});
      end
    },

    {
      "karb94/neoscroll.nvim",
      config = function ()
        require('neoscroll').setup({})
      end
    },
    --{"rakr/vim-one"}
    -- Colorscheme
    {
      --"navarasu/onedark.nvim",
      "rakr/vim-one",
      lazy = false,
      priority = 1000,
      init = function()
        vim.opt.background = dark
        vim.cmd("colorscheme one")
        vim.cmd("highlight Normal guibg=none")
        --vim.api.nvim_set_hl(0, "Normal", {bg = "NONE"})
      end
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "default" } },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false
  },
})

---
-- Configuration
---

local map = function(type, key, value)
  vim.keymap.set(type, key, value, {noremap = true, silent = true});
end

local lsp_attach = function(client)
  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
  map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
end


-- VIM OPT
vim.opt.guicursor       = ""
vim.opt.hlsearch        = false
vim.opt.incsearch       = true
vim.opt.hidden          = true
vim.opt.number          = true
vim.opt.relativenumber  = true
vim.opt.scrolloff       = 10
vim.opt.smartcase       = true
vim.opt.eol             = true
vim.opt.wrap            = false
vim.opt.swapfile        = false
vim.opt.backup          = false
vim.opt.undodir         = os.getenv("HOME").."/.vim/undodir"
vim.opt.undofile        = true
vim.opt.completeopt     = {"menuone", "noinsert" ,"noselect"}

vim.opt.clipboard:append("unnamedplus")
vim.opt.shortmess:append("c")

vim.opt.fo:remove("o")

vim.cmd("set scl=yes")




---
-- AUTOCMD
---

-- Trim white space
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})


-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.lsp.Client ~= nil then
      vim.lsp.buf.formatting_sync()
    end
  end,
})


-- Set tabs depending on filetype
vim.api.nvim_create_autocmd("Filetype", {
  callback = function()
    local ft, _ = vim.filetype.match({buf = vim.api.nvim_get_current_buf()})

    local tab_list = {
      ['tcl']           = 1,
      ['vhdl']          = 2,
      ['lua']           = 2,
      ['tex']           = 2,
      ['verilog']       = 2,
      ['systemverilog'] = 2,
      ['c']             = 8,
      ['cpp']           = 8,
      ['h']             = 8,
      ['hpp']           = 8,
    }

  local tab = tab_list[ft]

    if tab then
      vim.o.tabstop     = tab
      vim.o.softtabstop = tab
      vim.o.shiftwidth  = tab
    else
      vim.o.tabstop     = 4
      vim.o.softtabstop = 4
      vim.o.shiftwidth  = 4
    end

    vim.o.expandtab   = true
    vim.o.autoindent  = true
    vim.o.smartindent = true
  end
})


-- LaTeX and Text file single line arguments
vim.api.nvim_create_autocmd("Filetype", {
  pattern = {"tex", "text"},
  callback = function()
    vim.o.wrap        = true
    vim.o.linebreak   = true
    vim.o.breakindent = true
    vim.keymap.set("n", "j", "gj", {noremap = true, silent = true});
    vim.keymap.set("n", "k", "gk", {noremap = true, silent = true});
  end
})


-- DUMP TABLE
function dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

