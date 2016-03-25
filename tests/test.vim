let s:script_dir = expand('<sfile>:p:h')

func! test#source(...) abort
  for l:path in a:000
    for l:file in split(glob(l:path), '\n')
      exec join(['source', l:file])
    endfor
  endfor
endf

func! test#echo(...) abort
  echomsg join(['[TestRun]'] + a:000)
endf

func! test#run(...) abort
  try
    call test#source(join([s:script_dir, 'test/**/*.vim'], '/'))
    call test#docker#help()
    call test#docker#catch_err()
    call test#docker#setup()
    if metarw#docker#read('docker://images')[0] == 'browse' | call test#echo('read images') | endif
    if metarw#docker#read('docker://containers')[0] == 'browse' | call test#echo('read containers') | endif
    if metarw#docker#read('docker://containers/test/etc/group')[0] == 'read' | call test#echo('read container file') | endif
    call test#echo('success')
  catch
    echoerr v:exception
  endtry
endf

comm! Test call test#run()
auto! BufWrite *.vim source %
auto! BufWrite *.vim Test
