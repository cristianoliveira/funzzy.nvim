if exists("g:funzzy_loaded")
  finish
endif
let g:funzzy_loaded = 1

lua m = require("funzzy")

command! -nargs=* FunzzyClose lua m.FunzzyClose({ target = '<f-args>', split = '' })
command! -nargs=* FunzzyEdit lua m.FunzzyEdit({ target = '<f-args>', split = '' })
command! -nargs=* FunzzyInit lua m.FunzzyEdit({ target = '<f-args>', split = '' })

command! -nargs=* Fzz lua m.Funzzy({ target = '<f-args>', split = '' })
command! -nargs=* Funzzy lua m.Funzzy({ target = '<f-args>', split = '' })

command! -nargs=* Fze lua m.FunzzyEdit({ target = '<f-args>', split = '' })
command! -nargs=* FzzEdit lua m.FunzzyEdit({ target = '<f-args>', split = '' })
command! -nargs=* FzzInit lua m.FunzzyEdit({ target = '<f-args>', split = '' })

command! -nargs=1 Fzc lua m.FunzzyCmd({ command = '<f-args>', split = '' })
command! -nargs=1 FzzCmd lua m.FunzzyCmd({ command = '<f-args>', split = '' })
command! -nargs=1 FunzzyCmd lua m.FunzzyCmd({ command = '<f-args>', split = '' })

command! -nargs=* FunzzyClose lua m.FunzzyClose({ target = '<f-args>', split = '' })
command! -nargs=* FzzClose lua m.FunzzyClose({ target = '<f-args>', split = '' })
