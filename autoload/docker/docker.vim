func! docker#docker#cp(...)
  let l:src = get(a:, 1, '-')
  let l:dst = get(a:, 2, '-')

  return docker#docker('cp', l:src, l:dst)
endf

func! docker#docker#cpDir(...)
  let l:src = get(a:, 1, '-')
  let l:dst = get(a:, 2, tempname())

  return docker#docker('cp', l:src, '-', '>', l:dst)
endf
