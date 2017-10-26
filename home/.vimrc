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

" TODO Extend as needed
call MakeSpacelessIabbrev('gh/',  'http://github.com/')
call MakeSpacelessIabbrev('ghn/', 'http://github.com/netcarver/')
call MakeSpacelessIabbrev('me/',  'Netcarver')

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

" Formatting, TextMate-style
" nnoremap Q gqip
" vnoremap Q gq

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
"map // <Plug>(incsearch-easymotion-/)
"map /? <Plug>(incsearch-easymotion-?)
"map /g/ <Plug>(incsearch-easymotion-stay)

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

" I map tab to an extra control key - so this isn't really needed
" map <tab> %

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


autocmd filetype yaml,yml setlocal expandtab " No tabs in YAML files please.

" if exists(":Tabularize")
"     nmap <Leader>a= :Tabularize /=<cr>
"     vmap <Leader>a= :Tabularize /=<cr>
"     nmap <Leader>a> :Tabularize /=><cr>
"     vmap <Leader>a> :Tabularize /=><cr>
"	nmap <Leader>a: :Tabularize /:\zs<cr>
"	vmap <Leader>a: :Tabularize /:\zs<cr>
" endif


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



" " Allow searching php.net (and other online knowledgebases) for the
" " definition of the word under the cursor.
" function! OnlineDoc()
"   if &ft =~ "cpp"
"     let urlTemplate = "http://doc.trolltech.com/4.1/%.html"
"   elseif &ft =~ "ruby"
"     let urlTemplate = "http://www.ruby-doc.org/core/classes/%.html"
"   elseif &ft =~ "php"
"     let urlTemplate = "http://www.php.net/%"
"   elseif &ft =~ "module"
"     let urlTemplate = "http://www.php.net/%"
"   elseif &ft =~ "css"
"     let urlTemplate = "http://cssreference.io/property/%/"
"   elseif &ft =~ "htm"
"     let urlTemplate = "http://htmlreference.io/element/%/"
"   elseif &ft =~ "html"
"     let urlTemplate = "http://htmlreference.io/element/%/"
"   elseif &ft =~ "perl"
"     let urlTemplate = "http://perldoc.perl.org/functions/%.html"
"   else
"     return
"   endif
"   let browser = "/usr/bin/chromium-browser"
"   let wordUnderCursor = expand("<cword>")
"   let url = substitute(urlTemplate, "%", wordUnderCursor, "g")
"   let cmd = "silent !" . browser . " --incognito " . url
"   execute cmd
"   redraw!
" endfunction

" map <f1> :call OnlineDoc()<cr>

"" Setup VDebug options...
"let g:vdebug_features = { 'max_children': 128 }
"let g:vdebug_options = { 'on_close': 'stop',
""\ 'watch_window_style': 'compact',
"\ 'break_on_open': 0
""\ }
"let g:vdebug_options['break_on_open'] = 0

"" Easymotion plugin config
"let g:EasyMotion_keys = '123456789abcdefghijkmnopqrstuvwxyz'
"let g:EasyMotion_do_shade = 0

" " Setup signify
" let g:signify_vcs_list = [ 'git' ]

" " Setup delimitMate
" let g:delimitMate_expand_cr = 1

"" Setup UltiSnips
"
"" declare global configuration dictionary so that config options can be added:
"let g:UltiSnips = {}
"
"" customize mappings, eg use snipmate like behaviour
"let g:UltiSnips.ExpandTrigger = "<leader><leader>"
"" " It does make sense to not use <tab> here, use UltiSnips default <c-j>
"let g:UltiSnips.JumpForwardTrigger = "<tab><tab>"
"let g:UltiSnips.JumpBackwardTrigger = "<s-tab>"

" Now its time to tell UltiSnips about which snippets to load.
" You do so for snipmate snippets and UltiSnips snippets individually.
" This example illustrates a setup loading snipmate snippets.

" See plugin/UltiSnips.vim, it has much additional documentation.
" Assuming you're not overrding the default implemenation in the
" VimL function SnippetFilesForCurrentExpansionDefaultImplementation.

" == UltiSnips snippets ==
" Because I want to use the snipmate snippets 'default' does not load
" filetype.snippets snippet files.
" SirVer called the snippets to be present for all filetypes "all".
" So this fork follows his convention. Compare with _ which is used by
" snipmate but means the same.
"
" Now the default implementation reads &filetype, looks up the key in the
" dictionary and falls back to the default entry if there is no filetype
" specific entry.
"
" Thus if you're editing a cpp file ['cpp'] means that
" &rtp/UltiSnips/cpp.snippets and ..../all.snippets will be loaded if
" UltiSnips directory happens to be in your [._].vim directory only.
"
" For all other filetypes 'default' applies, which loads all.snippets
" from all &rtp/UltiSnips directories.
"let g:UltiSnips.UltiSnips_ft_filter = {
"            \ 'default' : {'filetypes': ['all'] },
"            \ 'all' : {'filetypes': ['all'] },
"            \ 'cpp' : {'filetypes': ['cpp', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
"            \ 'php' : {'filetypes': ['php', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
"            \ 'module' : {'filetypes': ['php', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
"            \ }
"" In the 'default' case the special word FILETYPE will be replaced by
"" &filetype, thus ['all','FILETYPE'] will load &rtp/html.snippets if
"" you're editing html files.
"
"" choices could be nasty, never show them
"let g:UltiSnips.always_use_first_snippet = 1
"
"" == snipmate snippets ==
"" _.snippets are meant to be snippets to be loaded always which is why
"" they are contained in all cases
"" This is pretty much the same as above:
"" * For html, xhtml snipmate &rtp/snippets/javascript snippets get loaded
"" * For cpp don't load any snipmate &rtp/snippets - because in this
""   example UltiSnips snippets are preferred
"let g:UltiSnips.snipmate_ft_filter = {
"            \ 'default' : {'filetypes': ["FILETYPE", "_"] },
"            \ 'html'    : {'filetypes': ["html", "javascript", "_"] },
"            \ 'xhtml'    : {'filetypes': ["xhtml", "html", "javascript", "_"] },
"            \ 'cpp'    : {'filetypes': [] },
"            \ }

"set runtimepath+=~/.vim/bundle/ultisnips
"" set runtimepath+=~/.vim/bundle/vim-snippets
"" let g:UltiSnipsSnippetDirectories=["~/.vim/UltiSnips", "~/.vim/snippets"]


" " Setup for Vim-airline statusbar plugin
" "
" " airline_powerline_fomts=1 is needed to allow seamless section melding
" let g:airline_powerline_fonts=1
" " airline_thme='<theme name>' selects one of the installed themes
" let g:airline_theme='badwolf'

"" Start NERDTree when vim starts and no file has been specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * nested if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"" Changing directory in NT changes vim's working directory
"" let NERDTreeChDirMode=2

"" Show hidden files by default
"let NERDTreeShowHidden=1

"" Quickly show NT with leader-d
"map <leader>d :NERDTreeToggle<cr>

"" Setup EditorConfig options...
"let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
"let g:EditorConfig_exec_path = '/usr/bin/editorconfig'




" Custom Configuration Inclusion ---------------------------------------------------------------------------------------
"
" All custom config settings are stored in the .vim/config folder to
" differentiate them from 3rd-party libraries.
runtime! config/**/*
