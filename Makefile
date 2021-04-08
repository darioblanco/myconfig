all: install configure sync

install:
	./install.sh

configure:
	./configure.sh

sync:
	./sync.sh
