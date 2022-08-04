" Plugin Section
call plug#begin('~\AppData\Local\nvim\plugged')
  Plug 'savq/melange'
"  Plug 'scrooloose/nerdtree'
"  Plug 'roxma/nvim-completion-manager' " causing python tracebacks???
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'ryanoasis/vim-devicons'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'jiangmiao/auto-pairs'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'sunjon/shade.nvim'
  Plug 'sudormrfbin/cheatsheet.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'jghauser/mkdir.nvim'
  Plug 'NTBBloodbath/galaxyline.nvim'
call plug#end()

"Config Section

if (has("termguicolors"))
 set termguicolors
endif

syntax enable
colorscheme melange

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" Automaticaly close nvim if NvimTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NvimTree") && b:NvimTree.isTabTree()) | q | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NvimTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Toggle
nnoremap <silent> <C-b> :NvimTreeToggle<CR>

" open new split panes to right and below
set splitright

set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" open terminal on ctrl+n

function! OpenTerminal()
  split term://bash
  resize 10
endfunction

nnoremap <c-n> :call OpenTerminal()<CR>

" use alt+hjkl to move between split/vsplit panels

tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-alt-t': 'tab split',
  \ 'ctrl-alt-s': 'split',
  \ 'ctrl-alt-v': 'vsplit'
  \}

set mouse=a

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua << EOF
require("bufferline").setup{}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require("shade").setup({
  overlay_opacity = 50,
  opacity_step = 1,
  keys = {
    brightness_up    = '<C-Up>',
    brightness_down  = '<C-Down>',
    toggle           = '<Leader>s',
  }
})
EOF
