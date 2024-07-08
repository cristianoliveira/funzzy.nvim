if exists("g:funzzy_loaded")
  finish
endif
let g:funzzy_loaded = 1

lua m = require("funzzy")

command! -nargs=* Fzz lua m.Funzzy({ target = '<f-args>', split = '' })

command! -nargs=* FzzEdit lua m.FunzzyEdit({ target = '<f-args>', split = '' })
command! -nargs=* FzzInit lua m.FunzzyEdit({ target = '<f-args>', split = '' })
command! -nargs=1 FzzCmd lua m.FunzzyCmd({ command = '<f-args>', split = '' })
command! -nargs=* FzzTerm lua m.FunzzyClose({ target = '<f-args>', split = '' })
