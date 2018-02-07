""" Package Manager """
" Install & Setup Vundle (i.e. package manager)
  let initVundle=0
  let vundleReadme=expand('~/.vim/bundle/Vundle.vim/README.md')
  if !filereadable(vundleReadme)
"    echo "Installing Vundle..."
"    echo ""
    silent !mkdir -p ~/.vim/bundle/Vundle.vim
    if executable("git")
      silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"    else
"      echo "Vundle not installed!"
    endif
    let initVundle=1
  endif
  
  if filereadable(vundleReadme)
    set nocompatible                                       " be iMproved, required
    filetype off                                           " required
  
    set rtp+=~/.vim/bundle/Vundle.vim                      " set the runtime path to include Vundle and initialize
    call vundle#begin()
  
    Plugin 'VundleVim/Vundle.vim'                          " let Vundle manage Vundle, required
  
    "*** Plugin(s) ***"
  
      Plugin 'surround.vim'
      "Plugin 'scrooloose/syntastic'
      Plugin 'kien/ctrlp.vim'
      Plugin 'rking/ag.vim'      
      Plugin 'Lokaltog/vim-easymotion'
      "Plugin 'taglist.vim'
      "Plugin 'Valloric/YouCompleteMe'
      Plugin 'kchmck/vim-coffee-script'
      Plugin 'octol/vim-cpp-enhanced-highlight'
  
    call vundle#end()                                      " required - All of your Plugins must be added before the following line
    filetype plugin indent on                              " required
  
    if initVundle == 1
      echo "Installing Plugins"
      :PluginInstall
    endif

  else 
    "*** Manual Install of Plugins ***""

    set runtimepath^=~/.vim/bundle/ctrlp.vim
  endif

  """ Without Vundle support :( Install & Setup """
  if executable("git")
    if !filereadable(expand('~/.vim/bundle/vim-csharp/README.md'))
      silent !git clone git://github.com/OrangeT/vim-csharp.git ~/.vim/bundle/vim-csharp
    endif
  endif
  set runtimepath^=~/.vim/bundle/vim-csharp

""" Configuration """

"" Plugins

" ctrlp
  "if exists('g:ctrlp_cmd') "find by command
  if !empty(glob("~/.vim/bundle/ctrlp.vim")) " find by path
    let g:ctrlp_map = '<c-p>'
    "let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_switch_buffer = 0
    let g:ctrlp_match_window = 'bottom,order:ttb,min:5,max:25,results:100' 
    let g:ctrlp_custom_ignore = {  
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|node_modules$',
      \ 'file': '\.exe$\|\.o$\|\.dll$\|\.lst$' }
        
    " The Silver Searcher
    if executable('ag')
      " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      " ag is fast enough that CtrlP doesn't need to cache, however, with bigger results listing lets cache
      let g:ctrlp_use_caching = 1
    endif
  endif

" Syntastic
  if !empty(glob("~/.vim/bundle/syntastic")) " find by path
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
  endif

"" Options
hi statusline guifg=Grey guibg=Black ctermfg=7 ctermbg=0   " status bar color schema
syntax on                                                  " turn sytanx highlighting enabled

"" Key Mappings

  map <space> :
  "nnoremap <c-space> /
  
  " open explore
  nnoremap <c-e> :Explore<cr>
  
  " close buffer
  map <c-c> :bd<cr>
  
  " add tab/space in Explore tree (cleaner)
  let mapleader=" "
  let g:netrw_liststyle=3
  
  map <leader>ss :setlocal spell!<cr>                      " ss will toggle and untoggle spell checking
  
  " Split navigation
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>
  " Split vertical and horizontal
  nnoremap + <C-w>v
  nnoremap - <C-w>s

"" Settings

  "set list                                                 " show hidden characters
  set autoread                                             " reload changed files
  set lazyredraw                                           " faster response
  set splitbelow                                           " open horizontal splits on the right
  set splitright                                           " open vertical splits below
  set cmdheight=2                                          " message height in command window
  "set expandtab                                            " Use spaces instead of tabs
  set smarttab                                             " Be smart when using tabs
  set softtabstop=2                                        " soft tabs, ie. number of spaces for tab
  set tabstop=2                                            " global tab width
  set hidden                                               " handle multiple buffers better
  set laststatus=2                                         " Always show the status line
  set wildmenu                                             " Turn on the WiLd menu
  "set number                                               " show line numbers
  set ruler                                                " Always show current position
  set smartcase                                            " When searching try to be smart about cases
  set ignorecase                                           " case-insensitive searching
  set incsearch                                            " highlight matches as you type
  set hlsearch                                             " highlight matches
  set incsearch                                            " Makes search act like search in modern browsers
  set magic                                                " For regular expressions turn magic on
  set autoindent                                           " always set autoindenting on
  set copyindent                                           " copy the previous indentation on autoindenting
  set expandtab                                            " use spaces instead of tabs
  
  set noswapfile                                           " don't use swp files
  
  set pastetoggle=<Insert>                                 " Paste with <INSERT> without comments
  
  set ai "Auto indent
  set si "Smart indent
  set wrap "Wrap lines
  
  " Configure backspace so it acts as it should (in my mind)
  set backspace=eol,start,indent
  set whichwrap+=<,>,h,l

"" Helpers

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
  set viminfo^=%  " remember info about open buffers on close
