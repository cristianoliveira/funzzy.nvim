# funzzy.nvim [![CI checks](https://github.com/cristianoliveira/funzzy.nvim/actions/workflows/on-push-main.yml/badge.svg)](https://github.com/cristianoliveira/funzzy.nvim/actions/workflows/on-push-main.yml)

The plugin for running [funzzy](https://github.com/cristianoliveira/funzzy) the watcher inside of Neovim. 

This Neovim plugin allows you to watch for changes in files and directories and execute shell commands when they happen. It can be configured to run custom configurations by using `:FzzEdit` or run arbitrary commands for the current working directory with `:FunzzyCmd`.

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


https://github.com/cristianoliveira/funzzy.nvim/assets/3959744/fb74764a-eac4-4d23-ac0a-662527a38078


## Installation

### Requirements
 
 - Make sure you have the latest version of [funzzy installed](https://github.com/cristianoliveira/funzzy#installing) 
 - Or [cargo installed](https://doc.rust-lang.org/cargo/getting-started/installation.html) (see below)

To install this plugin, you can use your favorite plugin manager.

[vim-plug](https://github.com/junegunn/vim-plug) or [vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'cristianoliveira/funzzy.nvim', { 'do': 'cargo install funzzy' }
```

[packer](https://github.com/wbthomason/packer.nvim)

```lua
-- To install fzz using cargo
use { 'cristianoliveira/funzzy.nvim', run = 'cargo install funzzy' }

-- If you have fzz already installed use `fzz_bin`
use {
 g 'cristianoliveira/funzzy.nvim',
  config = function()
    vim.o.fzz_bin = '~/.cargo/bin/fzz'
  end,
}
```

It assumes you have [cargo installed](https://doc.rust-lang.org/cargo/getting-started/installation.html) for other options to install funzzy cli see: https://github.com/cristianoliveira/funzzy#installing

## Getting started

Create the `.watch.yaml` for the working project by running `:FzzInit` add the rules and commands for funzzy ([See examples](https://github.com/cristianoliveira/funzzy/tree/master/examples)) and then run `:Funzzy` that should be it, now evertime any file changing that matches the defined rules will be executed by funzzy and the output send to the current buffer.

## Usage

See `:help Funzzy` or check [the docs](https://github.com/cristianoliveira/funzzy.nvim/blob/main/doc/funzzy.txt)

```txt
COMMANDS                                                  *funzzy-commands*

                                                          *:FzzEdit*
:FzzEdit                       Opens the `.watch.yaml` file in edit mode. If
                                  the file does not exist, it will be created.

:FzzInit                       Alias for :FunzzyEdit

                                                          *:Fzz*
:Fzz <target>                  Watches using the `.watch.yaml` file in the
                                  current directory. you may pass a `target` to
                                  run a specific task.
                                  See more about "targeting"
                                  https://github.com/cristianoliveira/funzzy#running

                                                          *:FzzCmd*
:FzzCmd <shell-command>        Watches the current directory and runs the
                                  given shell command on each change.

                                                          *:FzzTerminate*
:FzzTerminate                      Closes all funzzy channels for the current
                                  working directory. This IS NOT REQUIRED for
                                  cleaning up running processes before exiting vim

```

## CI checks

### Unit tests

#### Requirement
 - luarocks see: https://luarocks.org/
 - busted see: https://lunarmodules.github.io/busted/
 - luacheck see: https://github.com/mpeterv/luacheck

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
