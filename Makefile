.PHONY: helptags
helptags:
	@nvim -c 'helptags doc' -c 'q'

.PHONY: test
test:
  @busted lua/
