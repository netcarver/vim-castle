" Setup UltiSnips

" declare global configuration dictionary so that config options can be added:
let g:UltiSnips = {}

" customize mappings, eg use snipmate like behaviour
let g:UltiSnips.ExpandTrigger = "<leader><leader>"
" " It does make sense to not use <tab> here, use UltiSnips default <c-j>
let g:UltiSnips.JumpForwardTrigger = "<tab><tab>"
let g:UltiSnips.JumpBackwardTrigger = "<s-tab>"

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
let g:UltiSnips.UltiSnips_ft_filter = {
            \ 'default' : {'filetypes': ['all'] },
            \ 'all' : {'filetypes': ['all'] },
            \ 'cpp' : {'filetypes': ['cpp', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
            \ 'php' : {'filetypes': ['php', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
            \ 'module' : {'filetypes': ['php', 'all'], 'dir-regex': '[._]vim/UltiSnips$' },
            \ }
" In the 'default' case the special word FILETYPE will be replaced by
" &filetype, thus ['all','FILETYPE'] will load &rtp/html.snippets if
" you're editing html files.

" choices could be nasty, never show them
let g:UltiSnips.always_use_first_snippet = 1

" == snipmate snippets ==
" _.snippets are meant to be snippets to be loaded always which is why
" they are contained in all cases
" This is pretty much the same as above:
" * For html, xhtml snipmate &rtp/snippets/javascript snippets get loaded
" * For cpp don't load any snipmate &rtp/snippets - because in this
"   example UltiSnips snippets are preferred
let g:UltiSnips.snipmate_ft_filter = {
            \ 'default' : {'filetypes': ["FILETYPE", "_"] },
            \ 'html'    : {'filetypes': ["html", "javascript", "_"] },
            \ 'xhtml'    : {'filetypes': ["xhtml", "html", "javascript", "_"] },
            \ 'cpp'    : {'filetypes': [] },
            \ }

set runtimepath+=~/.vim/bundle/ultisnips
" set runtimepath+=~/.vim/bundle/vim-snippets
" let g:UltiSnipsSnippetDirectories=["~/.vim/UltiSnips", "~/.vim/snippets"]
