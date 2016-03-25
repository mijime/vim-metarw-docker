let s:save_cpo = &cpo
set cpo&vim

let s:tempfile = get(s:, 'tempfile', tempname())

function! metarw#docker#read(fakepath) abort
  let _ = s:parse_incomplete_fakepath(a:fakepath)

  if _.mode == 'container_files'
    call s:regist_docker_command()
    return s:fetch_docker_container_files(_.pathlist)

  elseif _.mode == 'container_file'
    call s:regist_docker_command()
    return s:fetch_docker_container_file(_.pathlist)

  elseif _.mode == 'containers'
    return s:fetch_docker_containers(_.pathlist)

  elseif _.mode == 'images'
    return s:fetch_docker_images(_.pathlist)
  endif

  return ['browse', map(['containers', 'images'],
        \ '{"label": v:val, "fakepath": printf("docker://%s/", v:val)}')]
endfunction

function! metarw#docker#write(fakepath, line1, line2, append_p) abort
  let _ = s:parse_incomplete_fakepath(a:fakepath)
endfunction

function! metarw#docker#complete(arglead, cmdline, cursorpos) abort
  return []
endfunction

function! s:fetch_docker_container_file(_) abort
  let srcpath = printf('%s:///%s', a:_[0], s:resolve_path(join(a:_[1:], '/')))
  call docker#docker#cp(srcpath, s:tempfile)
  return ['read', s:tempfile]
endfunction

function! s:fetch_docker_container_files(_) abort
  let files = docker#docker#ls(a:_[0], join(['//'] + a:_[1:], '/'))
  return ['browse', map(files, 's:parse_docker_container_file(a:_, v:val)')]
endfunction

function! s:parse_docker_container_file(pathlist, _) abort
  return {'label': a:_, 'fakepath': s:resolve_path(printf('docker://containers/%s/%s', join(a:pathlist, '/'), a:_))}
endfunction

function! s:fetch_docker_containers(_) abort
  return ['browse', map(docker#docker#ps(), 's:parse_docker_container(v:val)')]
endfunction

function! s:parse_docker_container(_) abort
  return {'label': join(a:_, '  '), 'fakepath': printf('docker://containers/%s/', a:_[0])}
endfunction

function! s:fetch_docker_images(_) abort
  return ['browse', map(docker#docker#images(), 's:parse_docker_image(v:val)')]
endfunction

function! s:parse_docker_image(_) abort
  return {'label': join(a:_, '  '), 'fakepath': printf('docker://images/%s:%s/', a:_[0], a:_[1])}
endfunction

function! s:parse_incomplete_fakepath(incomplete_fakepath) abort
  let incomplete_fakepath = s:resolve_path(a:incomplete_fakepath)
  let fragments = matchlist(incomplete_fakepath, '^docker://\([^/]\+\)\?\(/[^@=*]*\)\?\([@=*]\)\?$')

  if len(fragments) <= 1
    echoerr 'Unexpected a:incomplete_fakepath:' string(incomplete_fakepath)
    throw 'metarw:docker#e1'
  endif

  let _ = {}
  let _.given_fakepath = incomplete_fakepath
  let _.pathlist = split(fragments[2], '/\+')
  let _.filename = split(fragments[2], '/\+', 1)[-1]
  let _.filemode = fragments[3]

  if fragments[1] =~ '^i'
    let _.mode = 'images'
    return _
  endif

  if fragments[1] =~ '^c'
    if len(_.pathlist) <= 0
      let _.mode = 'containers'
      return _

    elseif _.filename == ''
      let _.mode = 'container_files'
      return _

    else
      let _.mode = 'container_file'
      return _
    endif
  endif

  let _.mode = ''
  return _
endfunction

function! s:resolve_path(incomplete_fakepath) abort
  let incomplete_fakepath = substitute(a:incomplete_fakepath, '\\', '/', 'g')
  return substitute(incomplete_fakepath, '/[^/]*/\.\./\|/\./', '/', 'g')
endfunction

function! s:regist_docker_command() abort
  command! -buffer -nargs=1 DockerExec echo s:docker_exec(<f-args>)
  command! -buffer -nargs=? DockerLogs echo s:docker_logs(<f-args>)
endfunction

function! s:docker_exec(...) abort
  let _ = s:parse_incomplete_fakepath(expand('%'))
  return docker#apply(['exec', _.pathlist[0]] + a:000)
endfunction

function! s:docker_logs(...) abort
  let _ = s:parse_incomplete_fakepath(expand('%'))
  return docker#apply(['logs'] + a:000 + [_.pathlist[0]])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
