" .vimrc file
" Eduardo Fernandes de Conto
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:

" Environment {
        set nocompatible        " must be first line : use Vim settings
" }

" General {
    " pathogen
    call pathogen#infect()
    call pathogen#helptags()

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set history=1000            " Store a ton of history (default is 20)
    set nospell                 " Spell checking off
    set showcmd                 " display incomplete commands
    " Setting up the directories {
    set backup          " backups are nice ...
    set undolevels=1000 "maximum number of changes that can be undone

    au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
    au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    
    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.
    " Only define it when not defined already.
    if !exists(":DiffOrig")
        command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                    \ | wincmd p | diffthis
    endif
" }

" Vim UI {
    set cursorline " Highlight current line
    set backspace=indent,eol,start " allow backspacing over everything in insert mode
    set linespace=0
    set showmatch " show matching brackets/parenthesis
    set incsearch " find as you type search
    set hlsearch " highlight search terms
    set winminheight=0 " windows can be 0 line high
    set ruler                       " show the cursor position all the time
    set showcmd                     " show partial commands in status line 
                                                    "   and selected characters/lines in visual mode
    set mouse=a                     " Enable mouse usage automatically
    set mousemodel=popup            " popup mouse model

" }

" Formatting { 
    set wrap                     " wrap long lines
    set linebreak                " break at complete string (not in the middle of the word) 
    set autoindent                 " indent at the same level of the previous line
    set smartindent              " smart indenting (C-like programs,...) 
    set shiftwidth=2             " use indents of 2 spaces
    set expandtab                " tabs are spaces, not tabs
    set tabstop=2                " an indentation every two columns
    set softtabstop=2            " let backspace delete indent
    
    autocmd FileType text set textwidth=80 " line break at 80 caracters
    autocmd BufRead,BufNewFile *.txt,*.tex 
            \ set textwidth=0 wrapmargin=0 " don't line break for .txt and .tex files
" }

" Key (re)Mappings {
    " Mapping <Esc> key to jk : quicker
    :imap jk <Esc>

    " Easier saving with CTRL-S
    nmap <c-s> :w<CR>
    imap <c-s> <Esc>:w<CR>a

    " Go up/down in the visual line (wrapped line) instead of the line in the
    "file 
    noremap j gj
    noremap k gk
    
    ",cd : change working dir to current file dir
    nnoremap ,cd :cd %:p:h<CR>:pwd<CR>
" }

" Plugins {
" ctrlp
let g:ctrlp_custom_ignore = {'file': '\v(\.pyc|\.swp)$'}

" pyflakes
" do not use quickfix with pyflakes
let g:pyflakes_use_quickfix = 0

" flake8
" ignore white space of empty line warning for flake8
let g:flake8_ignore="W293"
let g:flake8_max_line_length=99
" autorun flake8 on save
autocmd BufWritePost *.py call Flake8()

" supertab
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" NERDTree
" ignore in NERDTree files that end with pyc and ~
let NERDTreeIgnore=['\.pyc$', '\~$']

" Latex-Suite
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
" }

" My Functions {
function! InitializeDirectories()
    let separator = "."
    let parent = $HOME 
    let prefix = '.vim'
    let dir_list = { 
                \ 'backup': 'backupdir', 
                \ 'views': 'viewdir', 
                \ 'swap': 'directory' }

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else  
            let directory = substitute(directory, " ", "\\\\ ", "")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }
