" Setup VDebug options...
let g:vdebug_features = { 'max_children': 128 }
let g:vdebug_options = { 'on_close': 'stop',
\ 'watch_window_style': 'compact',
\ 'break_on_open': 0
\ }

" Stop vdebug from stopping execution when opening.
"
" I don't need this as I usually set a breakpoint before launching an xdebug session.
let g:vdebug_options['break_on_open'] = 0
