let g:docker#command = get(g:, 'docker#command', 'docker')
let g:docker#options = get(g:, 'docker#options', [])

func! docker#call(...) abort
  let command = join([g:docker#command] + g:docker#options + a:000)
  let res = system(command)

  if v:shell_error | throw res | end

  return res
endf

func! docker#apply(...) abort
  return call('docker#call', a:000[0] + a:000[1:])
endf
