augroup DockerEdit
  au!
  au BufReadCmd docker://*
        \ call docker#edit#doautocmd('BufReadPre', expand('<amatch>')) |
        \ call docker#edit#read(expand('<amatch>')) |
        \ call docker#edit#doautocmd('BufReadPost', expand('<amatch>'))
  au FileReadCmd docker://*
        \ call docker#edit#doautocmd('FileReadPre', expand('<amatch>')) |
        \ call docker#edit#read(expand('<amatch>')) |
        \ call docker#edit#doautocmd('FileReadPost', expand('<amatch>'))
  au BufWriteCmd docker://*
        \ call docker#edit#doautocmd('BufWritePre', expand('<amatch>')) |
        \ call docker#edit#write(expand('<amatch>')) |
        \ call docker#edit#doautocmd('BufWritePost', expand('<amatch>'))
  au FileWriteCmd docker://*
        \ call docker#edit#doautocmd('FileWritePre', expand('<amatch>')) |
        \ call docker#edit#write(expand('<amatch>')) |
        \ call docker#edit#doautocmd('FileWritePost', expand('<amatch>'))
augroup END

comm! -nargs=* DockerBrowse call docker#edit#browse(<q-args>)
