" Settings for ack.vim plugin

" try to use silver searcher if available...
if executable('ag')
  let g:ackprg='ag --vimgrep'
  set grepprg=ag\ --nogroup\ --nocolor
endif

map <leader>a :Ack
nnoremap <leader>* :grep! "\b<c-r><c-w>\b"<cr>:cw<cr>
