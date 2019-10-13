#!/bin/bash -l

mkdir -p ~/.conky/ConkyPi/
mkdir -p ~/Dropbox/ConkyPi/Pictures/.show_pics
touch ~/Dropbox/ConkyPi/conkypi_text.txt
cp -r PNG ~/.conky/ConkyPi/
cp commands_pictures.sh ~/Dropbox/ConkyPi/Pictures/.commands_pictures.sh
cp conky_config ~/.conky/ConkyPi/
cp openweather.py ~/.conky/ConkyPi/
cp settings.lua ~/.conky/ConkyPi/
cp start_conky.sh ~/.conky/ConkyPi/
chmod +x ~/.conky/ConkyPi/start_conky.sh
chmod +x ~/.conky/ConkyPi/openweather.py
chmod +x ~/Dropbox/ConkyPi/Pictures/.commands_pictures.sh
