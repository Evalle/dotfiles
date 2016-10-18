execute pathogen#infect()
syntax on

scriptencoding utf-8
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set smarttab
set et 
set expandtab

" Status line
    set laststatus=2
    set statusline=
    set statusline+=%-3.3n\                      " buffer number
    set statusline+=%f\                          " filename
    set statusline+=%h%m%r%w                     " status flags
    set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
    set statusline+=%=                           " right align remainder
    set statusline+=0x%-8B                       " character value
    set statusline+=%-14(%l,%c%V%)               " line, character
    set statusline+=%<%P                         " file position

" Show line number, cursor position
set ruler

" Display incomplete commands
set showcmd

" Search as you type
set incsearch

" Ignore case when searching
set ignorecase

" Highlight current line number
"set cursorline

set wrap

set ai 
set cin 

set showmatch
set hlsearch
set incsearch
set ignorecase

set lz 

set listchars=tab:··
set list

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866


if !has('gui_running')
set mouse=
endif

set guioptions-=T
set guioptions-=m

" set number
set autoindent

set number 

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw

if ! has("gui_running")
    set t_Co=256
endif
" feel free to choose :set background=light for a different style
set background=dark
colors monokai

"try
"    colorscheme desert
"catch
"endtry

" set background=dark

" Set extra options when running in GUI mode
"if has("gui_running")
"    set guioptions-=T
"    set guioptions-=e
"    set t_Co=256
"    set guitablabel=%M\ %t
"endif

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" pathogen
execute pathogen#infect()
filetype plugin indent on
let g:jedi#auto_initialization = 0

" column settings
set colorcolumn=78,85

" smooth scrolling 
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 40, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 40, 4)<CR>

" vim airline, show special symbols
let g:airline_powerline_fonts = 1
