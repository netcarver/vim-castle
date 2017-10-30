" Pathogen setup -------------------------------------------------------------------------------------------------------
"
" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
filetype off
call pathogen#helptags()
call pathogen#incubate()
filetype plugin indent on


" Basic options --------------------------------------------------------------------------------------------------------

" We don't need vi compatibility
set nocompatible

set encoding=utf-8
set termencoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set noerrorbells    " No bell sounds please!
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set number           " always show line numbers
                     " allow backspacing over everything in insert mode
set norelativenumber " Don't show relative distance (in lines) from the current line
set numberwidth=5    " Width of line number gutter
set laststatus=2
set history=100
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set matchtime=3
set matchpairs+=<:> " Helps with xml and html
set showbreak=↪
set splitbelow
set splitright
set shiftround
set title
set linebreak
set colorcolumn=+1
set textwidth=120
set mouse=a          " I find having mouse support helpful for quickly resizing window splits.

" Allow hyphens in words
set iskeyword+=-

" Use font with glyphs for powerline
set guifont=Droid\ Sans\ Mono\ Slashed\ For\ Powerline\ 8

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" I usually only edit files with unix line endings.
set ff=unix

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Leader
let mapleader = ","
let maplocalleader = "\\"


" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END


set switchbuf=usetab,newtab " Buffers open in existing or new tabs please

let Tlist_GainFocus_On_ToggleOpen = 1 " Taglist gets focus when opened


" Trailing whitespace
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:⌴
    au InsertLeave * :set listchars+=trail:⌴
augroup END


" Wildmenu completion

set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib


" Line Return

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
" Very, very useful!
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END


" Tabs, spaces, wrapping
set tabstop=4      " a tab is how many spaces?
set shiftwidth=4   " number of spaces to use for autoindenting
set softtabstop=4
set nowrap         " don't wrap lines
set expandtab      " use spaces instead of tabs
set copyindent     " copy the previous indentation on autoindenting
set smarttab       " insert tabs on the start of a line according to
                   "    shiftwidth, not tabstop

au BufRead,BufNewFile *.php set filetype=php
au BufRead,BufNewFile *.tpl set filetype=php
au BufRead,BufNewFile *.module set filetype=php
au BufRead,BufNewFile *.info set filetype=php
au BufRead,BufNewFile *.inc set filetype=php
au BufRead,BufNewFile *.scss set filetype=css
au BufRead,BufNewFile *.sass set filetype=css


" Backups

set backup                        " enable backups
set noswapfile                    " it's 2017, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif


" Color scheme ---------------------------------------------------------------------------------------------------------

"let g:solarized_termcolors=256

syntax enable
set background=dark
colorscheme solarized

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'



" Abbreviations --------------------------------------------------------------------------------------------------------

function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<cr>"
endfunction
function! MakeSpacelessBufferIabbrev(from, to)
    execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<cr>"
endfunction

" A few shortcuts PHP stuff: helps make snipmate snippets more useable.
call MakeSpacelessIabbrev('t',  '$this->')

" Quickly continue inserting at the end of the current line without having to reach for the <esc> key.
inoremap <leader>.. <esc>/)<cr>:noh<cr>a
inoremap <leader>> <esc>/}<cr>:noh<cr>a


" Convenience mappings -------------------------------------------------------------------------------------------------

" Toggle line numbers
nnoremap <leader>n :setlocal number!<cr>


" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" "Uppercase word" mapping.
"
" This mapping allows you to press <c-u> in insert mode to convert the current
" word to uppercase.  It's handy when you're writing names of constants and
" don't want to use Capslock.
"
" To use it you type the name of the constant in lowercase.  While your
" cursor is at the end of the word, press <c-u> to uppercase it, and then
" continue happily on your way:
"
"                            cursor
"                            v
"     max_connections_allowed|
"     <c-u>
"     MAX_CONNECTIONS_ALLOWED|
"                            ^
"                            cursor
"
" It works by exiting out of insert mode, recording the current cursor location
" in the z mark, using gUiw to uppercase inside the current word, moving back to
" the z mark, and entering insert mode again.
"
" Note that this will overwrite the contents of the z mark.  I never use it, but
" if you do you'll probably want to use another mark.
inoremap <C-u> <esc>mzgUiw`za
nnoremap <C-u> gUiw

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Easier linewise reselection of what you just pasted.
nnoremap <leader>V V`]

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting lines into external apps.
nnoremap vv ^vg_

" Fix a few of my common typos...
inoremap 0_ ()
inoremap )_ ()

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null
"   cmap w!! w !sudo tee % >/dev/null

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>


" Quick editing --------------------------------------------------------------------------------------------------------

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>eb :vsplit ~/.bashrc<cr>
nnoremap <leader>et :vsplit ~/.tmux.conf<cr>


" Searching and movement -----------------------------------------------------------------------------------------------

" Use sane regexes.
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and column - which is more useful, so make it easy
nnoremap ' `
nnoremap ` '

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
"set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

" Mappings
inoremap jj <esc>
inoremap kk <esc>:w<cr>a
inoremap <c-s> <esc>:w<cr>a

" Short cut to colon...
nnoremap ; :

" Shortcut ', ' to remove highlighting...
nnoremap <leader><space> :noh<cr>
" noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Make D behave
nnoremap D d$

" make Y consistent with C and D
nnoremap Y y$


" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

nnoremap * *<c-o>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" command mode jump to start/end (matches shell moves)
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>



" Whitespace -----------------------------------------------------------------------------------------------------------

" Show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red

" Manually clean trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z


" Setup function to do this on file exit
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction


if has("autocmd")
  autocmd FileType inc,info,tpl,module,css,scss,js,php,html,md,textile,javascript autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
  autocmd FileType yaml,yml setlocal expandtab " No tabs in YAML files please.
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
endif


" Shortcut to Taglist...
nnoremap <leader>z :TlistToggle<cr>

" Text bubbling uses unimpaired but I've had to disable
" unimpaired's mapping of all its 'firsts' to get the
" c-up and c-down keys working
" Bubble single lines...
nmap [B ]e
nmap [A [e
" Bubble multiple lines...
" vmap [A [egv
" vmap [B ]egv
" Bubble characters left or right (transpose)...
nmap [D x2hp
nmap [C xp

vnoremap . :normal .<cr>

" TMux inspired settings -----------------------------------------------------------------------------------------------

" Easy vertical and horizontal splits inspired by tmux
nnoremap <leader>\| <c-w>v
nnoremap <leader>- <c-w>s

" Allow tmux window switching...
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Add super-easy vim split navigation - simply cycle through by pressing enter in normal mode!
nnoremap <cr>  <c-w>w
autocmd Filetype nerdtree nmap <buffer> <cr> <c-w>w


"
" Filetype utility routines --------------------------------------------------------------------------------------------


" Turn on wrapping and spelling for file
function! s:setWrapping()
    setlocal wrap linebreak nolist spell
endfunction


if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  " Reload .vimrc after save
  au! BufWritePost .vimrc source %

  " Filetype settings on load
  au BufRead,BufNewFile *.m*down set filetype=markdown
  au BufRead,BufNewFile *.json set filetype=json

  au BufRead,BufNewFile *.txt, *.md, *.markdown, *.mkd call s:setWrapping()
endif


" Custom Configuration Inclusion ---------------------------------------------------------------------------------------
"
" All custom config settings are stored in the .vim/config folder to
" differentiate them from 3rd-party libraries.
runtime! config/**/*
