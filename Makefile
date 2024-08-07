.PHONY: helptags
helptags:
	@nvim -c 'helptags doc' -c 'q'

.PHONY: setup
setup:
	@luarocks install busted
	@luarocks install luacheck

.PHONY: test
test:
	@busted lua/

.PHONY: lint
lint:
	@luacheck lua

# Nix builds use this
.PHONY: install
install:
	@echo "Nothing to install"
