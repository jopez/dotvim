" .vimrc file
" Jose Pablo Escobedo (Copy of Eduardo Fernandes de Conto)
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:

" Environment {
    set nocompatible        " must be first line : use Vim settings
" }

" My Functions {

" Read-only & swap
" http://vim.wikia.com/wiki/Open_same_file_read-only_in_second_Vim
let s:swapCheckEnabled = 0
let s:_shm = &shm
function! ToggleSwapCheck()
  let s:swapCheckEnabled = !s:swapCheckEnabled
  if !s:swapCheckEnabled
    let &shm = s:_shm
  endif
  aug CheckSwap
    au!
    if s:swapCheckEnabled
      set shm+=A
      au BufReadPre * call CheckSwapFile()
      au BufRead * call WarnSwapFile()
    endif
  aug END
endfunction
call ToggleSwapCheck()

function! CheckSwapFile()
  if !exists('*GetVimCmdOutput') || !&swapfile || !s:swapCheckEnabled
    return
  endif

  let swapname = GetVimCmdOutput('swapname')
  if swapname =~ '\.sw[^p]$'
    set ro
    let b:_warnSwap = 1
  endif
endfunction

function! WarnSwapFile()
  if exists('b:_warnSwap') && b:_warnSwap && &swapfile
    echohl ErrorMsg | echomsg "File: \"" . bufname('%') .
     \ "\" is opened readonly, as a swapfile already existed."
     \ | echohl NONE
    unlet b:_warnSwap
  endif
endfunction

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

function! ToggleGUICruft()
  if &guioptions=='i'
    exec('set guioptions=imTrL')
  else
    exec('set guioptions=i')
  endif
endfunction

function! SetIndent(indent)
    let nb=a:indent+0
    let &shiftwidth=nb      " use indents of 'indent' spaces
    let &tabstop=nb         " an indentation every 'indent' columns
    let &softtabstop=nb     " let backspace delete indent
endfunction
command! -nargs=1 SetIndent call SetIndent(<f-args>)
" }



" General {
    " Pathogen
    call pathogen#infect()
    call pathogen#helptags()

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set history=1000            " Store a ton of history (default is 20)
    set nospell                 " Spell checking off
    set showcmd                 " display incomplete commands
    set smartcase               " Smart case when searching
    set number                  " Show line number
    set wildchar=<Tab> wildmenu wildmode=full " Convinient way to switch between buffers
    set wildcharm=<C-Z>
    set nofoldenable            " don't fold by default
    set wildmode=longest,list,full " when tapping tab, do not write whole word
    set wildmenu

    " Setting up the directories {
    set backup          " backups are nice ...
    set undolevels=1000 "maximum number of changes that can be undone

    au BufWinLeave .* mkview  "make vim save view (state) (folds, cursor, etc)
    au BufWinEnter .* silent loadview "make vim load view (state) (folds, cursor, etc)
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

    " Ignore BOOST, make auto-complete goes way faster!
    set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!

" }

" Vim UI {
    set cursorline                   " highlight cursorline
    " syntax enable
    " set background=dark
    " colorscheme solarized
    set backspace=indent,eol,start " allow backspacing over everything in insert mode
    set linespace=0
    set showmatch " show matching brackets/parenthesis
    set incsearch " find as you type search
    set hlsearch " highlight search terms
    set winminheight=0 " windows can be 0 line high
    set ruler                       " show the cursor position all the time
    set showcmd                     " show partial commands in status line 
                                    " and selected characters/lines in visual mode
    set mouse=a                  " Enable mouse usage automatically
    set mousemodel=popup            " popup mouse model
    set guioptions=i                " by default, hide gui menus
     
" }

" Formatting { 
    set wrap                     " wrap long lines
    set linebreak                " break at complete string (not in the middle of the word) 
    set autoindent               " indent at the same level of the previous line
    set smartindent              " smart indenting (C-like programs,...) 
    set shiftwidth=4             " use indents of 2 spaces
    set expandtab                " tabs are spaces, not tabs
    set tabstop=4                " an indentation every two columns
    set softtabstop=4            " let backspace delete indent
    
    autocmd FileType text set textwidth=80 " line break at 80 caracters
    autocmd BufRead,BufNewFile *.txt,*.tex 
            \ set textwidth=0 wrapmargin=0 " don't line break for .txt and .tex files

    call SetIndent(4)
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

    " Run cmaps in current dir
    map <C-F12> :!ctags -RI --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ .<CR>
    " map <C-F12> :!ctags -IR --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

    " Wildmenu for switching buffers
    nnoremap <F10> :b <C-Z>

    " Toogle toolbar show/hide
    map <F11> <Esc>:call ToggleGUICruft()<CR>

    " Ctrl del
    :imap <C-d> <C-[>diwi

" }

" Plugins {
    " supertab
    let g:SuperTabDefaultCompletionType = "context"
    set completeopt=menuone,longest,preview

    " NERDTree
    " ignore in NERDTree files that end with pyc and ~
    let NERDTreeIgnore=['\.pyc$', '\~$']
    " fix directory descending issue.
    let g:NERDTreeDirArrows=0

    " Ctags search path
    " Look everywhere until root.
    set tags=./tags;

    " Tagbar {
        let g:tagbar_ctags_bin='/usr/bin/ctags'
    " }

    " Man {
        runtime! ftplugin/man.vim
        nnoremap K :Man <cword><CR>
    " }
 
    " FSwitch {
        ",fs : Call FSwitch to change between header/source
        nnoremap ,fs :FSHere<CR>
    "

    " Tagbar {
        let g:tagbar_ctags_bin='/usr/bin/ctags'
    " }

    " Cscope {
        " Mappings {
            nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
            nnoremap <leader>l :call ToggleLocationList()<CR>
            " s: Find this C symbol
            nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
            " g: Find this definition
            nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
            " d: Find functions called by this function
            nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
            " c: Find functions calling this function
            nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
            " t: Find this text string
            nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
            " e: Find this egrep pattern
            nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
            " f: Find this file
            nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
            " i: Find files #including this file
            nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
        " }
        " Configs {
            let g:cscope_silent=1
        " }
    " }

    " CtrlP {
        call ctrlp_bdelete#init()
        nnoremap ,b :CtrlPBuffer<CR>
    " }

" }
