let s:urm = 'docker://\([^/]\+\)/\(.\+\)'
let s:temppath = get(s:, 'temppath', tempname())

func! docker#edit#path(uri)
  let l:uri = fnameescape(a:uri)
  return join([
        \ substitute(l:uri, s:urm, '\1', ''),
        \ substitute(l:uri, s:urm, '\2', '')], ':')
endf

func! docker#edit#doautocmd(command, uri)
  exec join(['silent', 'doautocmd', a:command, fnameescape(a:uri)])
endf

func! docker#edit#write(uri)
  let l:realpath = docker#edit#path(a:uri)

  exec join(['write!', s:temppath])

  return docker#docker#cp(s:temppath, l:realpath)
endf

func! docker#edit#read(uri)
  let l:realpath = docker#edit#path(a:uri)

  try
    call docker#docker#cp(l:realpath, s:temppath)
  catch
    if v:exception =~ 'no such file or directory'
    else
      throw v:exception
    end
  endtry

  exec join(['edit', s:temppath])
  exec join(['file', a:uri])
endf

func! docker#edit#browse(uri)
  let l:fname = join(['[docker::browse]', a:uri])
  let l:bufno = buffer_number(l:fname)
  if l:bufno >= 0
    exec join(['buffer', l:bufno])
    return
  end

  let l:realpath = docker#edit#path(a:uri)

  call docker#docker#cpDir(l:realpath, s:temppath)

  new | call tar#Browse(s:temppath)
  exec join(['file', l:fname])
endf
