PACKAGES := nvim ghostty zsh claude

all: sync

brew:
	brew bundle install --file=Brewfile

sync:
	stow -v -t ~ $(PACKAGES)

clean:
	stow -D -v -t ~ $(PACKAGES)

restow:
	stow -R -v -t ~ $(PACKAGES)

.PHONY: all clean sync restow brew
