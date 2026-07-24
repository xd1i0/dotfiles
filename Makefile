all: sync

sync:
	mkdir -p ~/.config

	[ -L ~/.config/nvim ] || [ -e ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim
	[ -L ~/.config/ghostty ] || [ -e ~/.config/ghostty ] || ln -s $(PWD)/ghostty ~/.config/ghostty

clean:
	[ ! -L ~/.config/nvim ] || rm -f ~/.config/nvim
	[ ! -L ~/.config/ghostty ] || rm -f ~/.config/ghostty

.PHONY: all clean sync
