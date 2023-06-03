# funzzy.nvim

It is a Neovim plugin that allows you to watch for changes in files and directories and take action when they occur. Configure custom tasks and commands for different directories.

```txt
FEATURES                                                  *funzzy-features*

- Runs a command when a file changes
- Uses a very lightweight watcher (funzzy)
- Can be configured by editing the .watch.yaml file or by passing an arbitrary
  command.
- Can be used to run tests, build, lint, etc.
- Runs a Non-blocking cancelable job
- Using `{{filename}}` allows you to compose commands that uses the changed file
```

## Installation

To install this plugin, you can use your favorite plugin manager.

[vim-plug](https://github.com/junegunn/vim-plug) or [vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'cristianoliveira/funzzy.nvim', { 'do': 'cargo install funzzy' }
```

[packer](https://github.com/wbthomason/packer.nvim)

```lua
use { 'cristianoliveira/funzzy.nvim', run = 'cargo install funzzy' }
```

## Usage

See `/docs/funzzy.txt`

```txt
COMMANDS                                                  *funzzy-commands*

                                                          *:FunzzyEdit*
:FunzzyEdit                       Opens the `.watch.yaml` file in edit mode. If
                                  the file does not exist, it will be created.

:FunzzyInit                       Alias for :FunzzyEdit

                                                          *:Funzzy*
:Funzzy <target>                  Watches using the `.watch.yaml` file in the
                                  current directory. you may pass a `target` to
                                  run a specific task.
                                  See more about "targeting"
                                  https://github.com/cristianoliveira/funzzy#running

                                                          *:FunzzyCmd*
:FunzzyCmd <shell-command>        Watches the current directory and runs the
                                  given shell command on each change.

:FunzzyTab <target>               Same as :Funzzy but opens the output in a
                                  new tab.
:FunzzyCmdTab <shell-command>     Same as :FunzzyCmd but opens the output in
                                  a new tab.

:FunzzyVSplit <target>            Same as :Funzzy but opens the output in a
                                  new vertical split.
:FunzzyCmdVSplit <shell-command>  Same as :FunzzyCmd but opens the output in
                                  a new vertical split.

:FunzzySplit <target>             Same as :Funzzy but opens the output in
                                  a new horizontal split.
:FunzzyCmdSplit <shell-command>   Same as :FunzzyCmd but opens the output in
                                  a new horizontal split
```

## Contributing

If you would like to contribute to Funzzy the Watcher, please feel free to open a pull request or issue on this repository.
