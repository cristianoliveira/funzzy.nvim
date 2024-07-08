#!/usr/bin/env bash

## Fail when missing required environment variables
nvim_bin=${NVIM_BIN:?"Missing NVIM_BIN environment variable"}

echo "test the commands are available"

ls -la 
lua -e 'print(package.path)'

# $nvim_bin --headless -c 'source plugin/funzzy.vim' -c 'FzzInit' -c 'qa!'
# $nvim_bin --headless -c 'source plugin/funzzy.vim' -c 'Fzz' -c 'qa!'
$nvim_bin \
  --headless -c 'source plugin/funzzy.vim' -c 'Fzz' -c 'qa!' \
  > test_results.log 2>&1
