"----- Load plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

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


"----- Setup
set clipboard+=unnamedplus

set guicursor=

set nohlsearch

set hidden

set relativenumber
set number
set scl=yes

set scrolloff=10

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap

set smartcase

"------ LSP
" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'


"imap <tab> <Plug>(completion_smart_tab)
"imap <s-tab> <Plug>(completion_smart_s_tab)
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
"
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<NUL>"
let g:UltiSnipsListSnippets="<NUL>"
let g:UltiSnipsJumpFowardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Avoid showing message extra message when using completion
set shortmess+=c

autocmd BufEnter * lua require'completion'.on_attach()

lua require'lspconfig'.clangd.setup{}
"{on_attach=require'completion'.on_attach}
lua require'lspconfig'.ghdl_ls.setup{}
"{on_attach=require'completion'.on_attach}

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
