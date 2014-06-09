" this is mostly a matter of taste. but LaTeX looks good with just a bit
" " of indentation.
set sw=2
" " TIP: if you write your \label's as \label{fig:something}, then if you
" " type in \ref{fig: and press <C-n> you will automatically cycle through
" " all the figure labels. Very useful!
set iskeyword+=:

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:


let g:tex_flavor = 'latex'

let g:Tex_MultipleCompileFormat = 'pdf,aux'
let g:Tex_TreatMacViewerAsUNIX = 0
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 --interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'Skim'

" Command-R will write, compile, and forward search--thanks to
" http://reference-man.blogspot.com/2011/09/fully-integrated-latex-in-macvim.html
" preview, switch back to main window
map <D-r> :w<cr><leader>ll<leader>ls
imap <D-r> <ESC><D-r>

let g:Tex_IgnoredWarnings ='
      \"Underfull\n".
      \"Overfull\n".
      \"specifier changed to\n".
      \"You have requested\n".
      \"Missing number, treated as zero.\n".
      \"There were undefined references\n".
      \"Citation %.%# undefined\n".
      \"Marginpar on page %.%# moved\n".
      \"\oval, \circle, or \line size unavailable\n"' 


" solving é, ã and â insertion problems
" http://dotfiles.org/~joaoTrindade/.vimrc
imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine
imap <buffer> <silent> <M-C> <Plug>Tex_MathCal
imap <buffer> <silent> <M-B> <Plug>Tex_MathBF
imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine

imap <buffer> <silent> <M-A> <M-A>
"imap <buffer> <silent> <M-E>  <Plug>Tex_InsertItem
""imap <buffer> <silent> <M-e>  <Plug>Tex_InsertItemOnThisLine
"imap <buffer> <silent> \c <Plug>Traditional
map <buffer> <silent> é é
map <buffer> <silent> á á
map <buffer> <silent> ã ã
"imap ã <Plug>Tex_MathCal
""imap é <Plug>Traditional
