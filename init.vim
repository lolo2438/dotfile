
call plug#begin()
" Textures
Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'

" Autocompletion
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'ms-jpq/chadtree'

" Latex
Plug 'lervag/vimtex'
Plug 'rhysd/vim-grammarous'

"Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'onsails/lspkind-nvim'

" Smooth scrolling
Plug 'karb94/neoscroll.nvim'

" Debugger adapter protocol
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'

"Directory
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'

call plug#end()

"----- Load colorscheme
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set background=dark
let g:airline_theme='one'
colorscheme one
highligh Normal guibg=none

"----- Setup
set clipboard+=unnamedplus

set guicursor=

set nohlsearch
set incsearch

set hidden

set relativenumber
set number
set scl=yes

set scrolloff=10

filetype detect
let f2 = ['vhdl', 'lua', 'tex', 'verilog', 'systemverilog']
let f8 = ['c', 'cpp', 'h', 'hpp']
let f1 = ['tcl']
set tabstop=4 softtabstop=4 shiftwidth=4

for i in f2
    if &filetype == i
        set tabstop=2 softtabstop=2 shiftwidth=2
        break
    endif
endfor

for i in f8
    if &filetype == i
        set tabstop=8 softtabstop=8 shiftwidth=8
        break
    endif
endfor

for i in f1
    if &filetype == i
        set tabstop=1 softtabstop=1 shiftwidth=1
        break
    endif
endfor

set expandtab
set autoindent
set smartindent
set nowrap

set smartcase

set eol

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

let ftxt = ['tex', 'text', '']
for i in ftxt
  if &filetype == i
    " Soft wrapping
    set wrap
    set linebreak
    set breakindent
    noremap j gj
    noremap k gk

    "Hard wrapping
    "set tw=100
    "set fo+=tpwb
  endif
endfor

if &filetype == 'vhdl'
  let g:vhdl_indent_genportmap = 0
endif

"Display hidden character
"set list
"set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

"------ Auto cmd
"let g:python3_host_prog="/bin/python3"

" Le programme qui format lit le STDIN (code) et output le code formatte dans
" STDOUT
"let g:formatdef_vhdl_formatter = '"nom_program --arguments"'
"let g:formatters_vhdl = ['vhdl_formatter']

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup LAURENT
    autocmd!
    autocmd BufWritePre * : call TrimWhiteSpace()
    "autocmd BufWrite * : AutoFormat
augroup END

"----- Remaps
"TODO: if there is a character at the right of the opening: don't do it
"inoremap ( ()<Left>
"inoremap <expr> ) search(')', 'n') ? <right> : )


"inoremap [ []<Left>
"inoremap { {}<Left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap <expr> <CR> search('{\%#}', 'n') ?
""\<CR>\<CR>\<Up>\<C-f>" :
"\<CR>"

"------ <leader>
let mapleader = " "


"------ LSP


" Avoid showing message extra message when using completion
set shortmess+=c
set completeopt=menuone,noinsert,noselect

"Remove comment header when using 'o' key
set fo-=o


let g:grammarous#jar_url = 'https://www.languagetool.org/download/LanguageTool-5.9.zip'
"let g:grammarous#languagetool_cmd = 'languagetool'

"--- VIMTEX
"let g:vimtex_view_method = ''
"let g:vimtex
lua <<EOF

  -- Neoscroll setup
  require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = true, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = true,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  })

  -- Setup nvim-cmp.
  --local cmp = require('cmp')
  --local lspkind = require('lspkind')

  --cmp.setup({
  --  snippet = {
  --    expand = function(args)
  --      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.
  --      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` user.
  --      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` user.
  --    end,
  --  },
  --  window = {
  --    -- completion = cmp.config.window.bordered(),
  --    -- documentation = cmp.config.window.bordered(),
  --  },
  --  formatting = {
  --      format = lspkind.cmp_format({
  --          mode = 'symbol',
  --          maxwidth = 50,
  --          symbols = 'codicons',

  --          before = function(entry, vim_item)
  --              vim_item.menu = ({
  --                nvim_lsp = "[LSP]",
  --                buffer   = "[BUF]",
  --              }) [entry.source.name]
  --              return vim_item;
  --          end
  --      })
  --  },
  --  mapping = cmp.mapping.preset.insert({
  --    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  --    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  --    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  --    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --    ['<C-Space>'] = cmp.mapping.complete(),
  --    ['<C-e>'] = cmp.mapping.close(),
  --    ['<CR>'] = cmp.mapping.confirm({
  --      --behavior = cmp.ConfirmBehavior.Replace,
  --      select = false
  --    }),
  --    ['<Tab>'] = function(fallback)
  --      if cmp.visible() then
  --        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --      else
  --        fallback()
  --      end
  --    end,
  --    ['<S-Tab>'] = function(fallback)
  --      if cmp.visible() then
  --        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  --      else
  --        fallback()
  --      end
  --    end,
  --  }),
  --  sources = cmp.config.sources({
  --    { name = 'nvim_lsp' },
  --    { name = 'vsnip' }, -- For vsnip user.
  --    -- { name = 'luasnip' }, -- For luasnip user.
  --    -- { name = 'ultisnips' }, -- For ultisnips user.
  --    { name = 'latex_symbols' },
  --    { name = 'nvim_lsp_document_symbol' },
  --    { name = 'nvim_lsp_signature_help' },
  --    {
  --      name = 'buffer',
  --      option = {
  --          keyword_pattern = [[\k\+]],
  --      }
  --    }
  --  })
  --})


  --cmp.setup.cmdline({ '/', '?' }, {
  --    mapping = cmp.mapping.preset.cmdline(),
  --    sources = {
  --        { name = 'buffer' }
  --        }
  --    }
  --)

  --cmp.setup.cmdline({ ':' }, {
  --    mapping = cmp.mapping.preset.cmdline(),
  --    sources = cmp.config.sources({
  --      { name = 'path' },
  --      {
  --          name = 'cmdline',
  --          option = {
  --            ignore_cmds = { }
  --          }
  --      }
  --    })
  --  }
  --)


--['text']            = 'ltex',
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

    local lsp = lsp_list[vim.bo.filetype];

    if lsp then
      -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      --capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

      --require('lspconfig')[lsp].setup {
      --  capabilities = capabilities,
      --  settings = settings(lsp),
      --}

      local lspconfig = require('lspconfig')

      vim.g.coq_settings = {
          auto_start = 'shut-up'
      }
      local coq = require('coq')

      lspconfig[lsp].setup(
        coq.lsp_ensure_capabilities({
            capabilities = capabilities,
            settings = settings(lsp),
            on_attach = lsp_attach,
        }))


    end
  end

EOF

