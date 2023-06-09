# funzzy.nvim [![CI checks](https://github.com/cristianoliveira/funzzy.nvim/actions/workflows/on-push-main.yml/badge.svg)](https://github.com/cristianoliveira/funzzy.nvim/actions/workflows/on-push-main.yml)

It is a Neovim plugin that allows you to watch for changes in files and directories and take action when they occur. Configure custom tasks and commands for different directories.

```txt
FEATURES                                                  *funzzy-features*

- Runs a command when a file changes
- Runs non-blocking cancelable tasks
- Can be used to run any kind of task with a single configuration file
- Can watch the current directory recursively and run arbitrary commands
- Using `{{filepath}}` allows you to compose commands that uses the changed file
- Uses a very lightweight process made with Rust

```
### Demo



https://github.com/cristianoliveira/funzzy.nvim/assets/3959744/eff1c5e5-5e64-4e6b-ab7a-8ac404a1861f



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

                                                          *:FunzzyClose*
:FunzzyClose                      Closes all funzzy channels for the current
                                  working directory. This IS NOT REQUIRED for
                                  cleaning up running processes before exiting vim

```

## CI checks

### Unit tests

#### Requirement
 - luarocks see: https://luarocks.org/
 - busted see: https://lunarmodules.github.io/busted/

```bash
luarocks install busted

make test
```

### Linter

```
luarocks install luacheck

make lint
```

## Contributing

If you would like to contribute to Funzzy the Watcher, please feel free to open a pull request or issue on this repository.
