
set nocompatible                                        " be iMproved, required
filetype off                                            " required

set rtp+=~/.vim/bundle/Vundle.vim                       " set the runtime path to include Vundle and initialize
call vundle#begin()

Plugin 'gmarik/Vundle.vim'                              " let Vundle manage Vundle, required

Plugin 'taglist.vim'
Plugin 'surround.vim'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Lokaltog/vim-easymotion'

call vundle#end()                                       " required " All of your Plugins must be added before the following line
filetype plugin indent on                               " required

map <space> :
map <c-space> /

map e :Explore<cr>
" add tab/space in Explore tree (cleaner)
let mapleader=" "
let g:netrw_liststyle=3

map c :bd<cr>                                           " close current buffer

map <leader>ss :setlocal spell!<cr>                     " ss will toggle and untoggle spell checking

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" vertical and horizontal split
nnoremap + <C-w>v
nnoremap - <C-w>s
set splitbelow                                          " open horizontal splits on the right
set splitright                                          " open vertical splits below

set expandtab                                           " Use spaces instead of tabs
set smarttab                                            " Be smart when using tabs
set softtabstop=2                                       " soft tabs, ie. number of spaces for tab
set tabstop=2                                           " global tab width
set hidden                                              " handle multiple buffers better
set laststatus=2                                        " Always show the status line
set wildmenu                                            " Turn on the WiLd menu
set number                                              " show line numbers
set ruler                                               " Always show current position
set smartcase                                           " When searching try to be smart about cases
set ignorecase                                          " case-insensitive searching
set incsearch                                           " highlight matches as you type
set hlsearch                                            " highlight matches
set incsearch                                           " Makes search act like search in modern browsers
set magic                                               " For regular expressions turn magic on
set autoindent                                          " always set autoindenting on
set copyindent                                          " copy the previous indentation on autoindenting
set expandtab                                           " use spaces instead of tabs

set noswapfile                                          " don't use swp files

set pastetoggle=<Insert>                                " Paste with <INSERT> without comments

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()
"autocmd BufWrite *.sh :call DeleteTrailingWS()

" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
set viminfo^=%  " Remember info about open buffers on close
