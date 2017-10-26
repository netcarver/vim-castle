" Start NERDTree when vim starts and no file has been specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * nested if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Changing directory in NT changes vim's working directory
" let NERDTreeChDirMode=2

" Show hidden files by default
let NERDTreeShowHidden=1

" Quickly show NT with leader-d
map <leader>d :NERDTreeToggle<cr>
