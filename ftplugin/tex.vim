" this is mostly a matter of taste. but LaTeX looks good with just a bit
" " of indentation.
set sw=2
" " TIP: if you write your \label's as \label{fig:something}, then if you
" " type in \ref{fig: and press <C-n> you will automatically cycle through
" " all the figure labels. Very useful!
set iskeyword+=:

let g:tex_flavor='latex'
let g:Tex_TreatMacViewerAsUNIX = 1
let g:Tex_ExecuteUNIXViewerInForeground = 1
let g:Tex_ViewRule_ps = 'open'
let g:Tex_ViewRule_pdf = 'open'
let g:Tex_ViewRule_dvi = 'open'

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
