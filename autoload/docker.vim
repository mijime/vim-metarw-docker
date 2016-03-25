let g:docker#command = get(g:, 'docker#command', 'docker')
let g:docker#options = get(g:, 'docker#options', [])

func! docker#call(...) abort
  let l:command = join([g:docker#command] + g:docker#options + a:000)
  let l:res = system(l:command)

  if v:shell_error | throw l:res | end

  return l:res
endf

func! docker#apply(...) abort
  return call('docker#docker', a:000[0] + a:000[1:])
endf
