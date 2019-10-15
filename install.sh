#!/bin/bash -l

if [ "$1" != "" ]; then
	mkdir -p ~/.conky/ConkyPi/
	mkdir -p ~/Dropbox/ConkyPi/$1/.tmp
	mkdir -p ~/Dropbox/ConkyPi/$1/Pictures/.show_pics
	touch ~/Dropbox/ConkyPi/$1/conkypi_text.txt
	touch ~/Dropbox/ConkyPi/$1/.tmp/.conkypi_text.txt
	cp -r PNG ~/.conky/ConkyPi/
	cat commands_pictures.sh |  sed "s/\[Device]/$1/g" | sponge ~/Dropbox/ConkyPi/$1/Pictures/.commands_pictures.sh
	cp conky_config ~/.conky/ConkyPi/
	cp openweather.py ~/.conky/ConkyPi/
	cat settings.lua | sed "s/\[Device]/$1/g" | sponge ~/.conky/ConkyPi/settings.lua
	cat start_conky.sh | sed "s/\[Device]/$1/g" | sponge ~/.conky/ConkyPi/start_conky.sh
	chmod +x ~/.conky/ConkyPi/start_conky.sh
	chmod +x ~/.conky/ConkyPi/openweather.py
	chmod +x ~/Dropbox/ConkyPi/$1/Pictures/.commands_pictures.sh
else
	echo "Please give your device a name!"
fi
