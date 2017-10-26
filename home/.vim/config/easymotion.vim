" Easymotion plugin config
let g:EasyMotion_keys = '123456789abcdefghijkmnopqrstuvwxyz'
let g:EasyMotion_do_shade = 0

" Is this the right place for this?
"
" Placing in a mappings file might be more appropriate
map // <Plug>(incsearch-easymotion-/)
map /? <Plug>(incsearch-easymotion-?)
map /g/ <Plug>(incsearch-easymotion-stay)
