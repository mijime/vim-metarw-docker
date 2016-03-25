function! docker#docker#cp(...) abort
  return docker#apply(['cp'] + a:000)
endfunction

function! docker#docker#images(...) abort
  return map(split(docker#apply(['images'] + a:000), '\n')[1:], 'split(v:val, "   *")')
endfunction

function! docker#docker#ps(...) abort
  return map(split(docker#apply(['ps'] + a:000), '\n')[1:], 'split(v:val, "   *")')
endfunction

function! docker#docker#exec(...) abort
  return docker#apply(['exec'] + a:000)
endfunction

function! docker#docker#ls(container, path) abort
  return split(docker#call('exec', a:container, 'ls', '-a', '-F', a:path), '\n')
endfunction
