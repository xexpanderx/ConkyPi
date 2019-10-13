#!/bin/bash
set +e
not_empty_folder=`find ~/Dropbox/ConkyPi/Pictures/* -not -path '*/\.*' -type f -name "*.*"`
if [ ! -z "$not_empty_folder" ]
then
	~/Dropbox/ConkyPi/Pictures/.commands_pictures.sh && cd ~/.conky/ConkyPi/ && conky -c conky_config
else
	echo "No pics found. Please add some pics in your pic folder."
fi
