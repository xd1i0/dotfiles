PACKAGES := nvim ghostty zsh claude fish

all: sync

brew:
	brew bundle install --file=Brewfile

sync:
	stow -v -t ~ $(PACKAGES)

fish-plugins:
	fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'

clean:
	stow -D -v -t ~ $(PACKAGES)

restow:
	stow -R -v -t ~ $(PACKAGES)

.PHONY: all clean sync restow brew fish-plugins
