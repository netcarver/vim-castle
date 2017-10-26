" Allow searching php.net (and other online knowledgebases) for the
" definition of the word under the cursor.
function! OnlineDoc()
  if &ft =~ "cpp"
    let urlTemplate = "http://doc.trolltech.com/4.1/%.html"
  elseif &ft =~ "ruby"
    let urlTemplate = "http://www.ruby-doc.org/core/classes/%.html"
  elseif &ft =~ "php"
    let urlTemplate = "http://www.php.net/%"
  elseif &ft =~ "module"
    let urlTemplate = "http://www.php.net/%"
  elseif &ft =~ "css"
    let urlTemplate = "http://cssreference.io/property/%/"
  elseif &ft =~ "htm"
    let urlTemplate = "http://htmlreference.io/element/%/"
  elseif &ft =~ "html"
    let urlTemplate = "http://htmlreference.io/element/%/"
  elseif &ft =~ "perl"
    let urlTemplate = "http://perldoc.perl.org/functions/%.html"
  else
    return
  endif
  let browser = "/usr/bin/chromium-browser"
  let wordUnderCursor = expand("<cword>")
  let url = substitute(urlTemplate, "%", wordUnderCursor, "g")
  let cmd = "silent !" . browser . " --incognito " . url
  execute cmd
  redraw!
endfunction

map <f1> :call OnlineDoc()<cr>
