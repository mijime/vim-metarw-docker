func! test#docker#setup(...) abort
  try
    call docker#call('rm test')
  catch
  endtry
  call docker#call('create', '--name', 'test', 'alpine', 'echo')
endf

func! test#docker#help(...) abort
  call test#echo('can be call a docker command')

  call docker#call('help')
endf

func! test#docker#catch_err(...) abort
  call test#echo('throw error if use undefine command')

  let l:catch_err = 0
  try
    call docker#call('undefine-command')
  catch
    let l:catch_err = 1
  endtry

  if ! l:catch_err
    throw 'non catched error'
  end
endf
