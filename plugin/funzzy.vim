if exists("g:funzzy_loaded")
  finish
endif
let g:funzzy_loaded = 1

lua m = require("funzzy")

command! -nargs=* FunzzyTest lua m.Funzzy({ target = '<f-args>', split = '' })

command! -nargs=* Funzzy lua m.Funzzy({ target = '<f-args>', split = '' })
command! -nargs=1 FunzzyCmd lua m.FunzzyCmd({ command = '<f-args>', split = '' })

command! -nargs=* FunzzyTab lua m.Funzzy({ target = '<f-args>', split = 't' })
command! -nargs=1 FunzzyTabCmd lua m.FunzzyCmd({ command = '<f-args>', split = 't' })

command! -nargs=* FunzzySplit lua m.Funzzy({ target = '<f-args>', split = 's' })
command! -nargs=1 FunzzySplitCmd lua m.FunzzyCmd({ command = '<f-args>', split = 's' })

command! -nargs=* FunzzyVplit lua m.Funzzy({ target = '<f-args>', split = 'v' })
command! -nargs=1 FunzzyVplitCmd lua m.FunzzyCmd({ command = '<f-args>', split = 'v' })
