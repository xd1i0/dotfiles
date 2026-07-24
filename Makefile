PACKAGES := nvim ghostty zsh

all: sync

sync:
	stow -v -t ~ $(PACKAGES)

clean:
	stow -D -v -t ~ $(PACKAGES)

restow:
	stow -R -v -t ~ $(PACKAGES)

.PHONY: all clean sync restow
