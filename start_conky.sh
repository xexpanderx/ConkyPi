#!/bin/bash
set +e
not_empty_folder=`find ~/Dropbox/ConkyPi/[Device]/Pictures/* -not -path '*/\.*' -type f -name "*.*"`
if [ ! -z "$not_empty_folder" ]
then
	echo "###Conky will spit out some lua errors in the beginning, but that is completely normal!"
	echo "###Lua needs some time..."
	~/Dropbox/ConkyPi/[Device]/Pictures/.commands_pictures.sh && cd ~/.conky/ConkyPi/ && conky -c conky_config
else
	echo "No pics found. Please add some pics in your pic folder."
fi
