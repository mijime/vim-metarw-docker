function! docker#docker#cp(...)
  return docker#apply(['cp'] + a:000)
endfunction

function! docker#docker#images(...)
  return map(split(docker#apply(['images'] + a:000), '\n'), 'split(v:val, "   *")')
endfunction

function! docker#docker#ps(...)
  return map(split(docker#apply(['ps'] + a:000), '\n'), 'split(v:val, "   *")')
endfunction

function! docker#docker#exec(...)
  return docker#apply(['exec'] + a:000)
endfunction

function! docker#docker#ls(container, path)
  return split(docker#docker('exec', a:container, 'ls', '-a', '-F', a:path), '\n')
endfunction
