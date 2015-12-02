func! test#docker#setup(...) abort
  try
    call docker#docker('rm test')
  catch
  endtry
  call docker#docker('create', '--name', 'test', 'alpine', 'echo')
endf

func! test#docker#help(...) abort
  call test#echo('can be call a docker command')

  call docker#docker('help')
endf

func! test#docker#catch_err(...) abort
  call test#echo('throw error if use undefine command')

  let l:catch_err = 0
  try
    call docker#docker('undefine-command')
  catch
    let l:catch_err = 1
  endtry

  if ! l:catch_err
    throw 'non catched error'
  end
endf

func! test#docker#read(...) abort
  call test#echo('can be read from docker container')
  call test#docker#setup()

  call docker#edit#read('docker://test/etc/group')
endf

func! test#docker#browse(...) abort
  call test#echo('can be browse from docker container')
  call test#docker#setup()

  :DockerBrowse docker://test/etc
endf
