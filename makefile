#!/usr/bin/env make -f

SHELL = /bin/zsh

TARGET_FILE = typewriter-math.cls

REMOTE = adarienzo@osmium.us.to
REMOTE_DIR = /home/adarienzo/.local/share/texmf/tex/latex/typewriter-math/typewriter-math.cls

local-install:
	$(info Updating local $(TARGET_FILE))
	cp ./$(TARGET_FILE) "$(TEXFOLDER)$(TARGET_FILE)"
	$(info Running local texhash. Do you have root privileges?)
	sudo texhash

remote-install:
	$(info Updating $(TARGET_FILE) on Osmium.)
	scp -i "$(HOME)/.ssh/id_ecdsa" ./$(TARGET_FILE) $(REMOTE):/$(REMOTE_DIR)
	$(info Executing texhash on remote:)
	ssh -t -i "$(HOME)/.ssh/id_ecdsa" $(REMOTE) 'sudo $$(which texhash)'

install: local-install remote-install
