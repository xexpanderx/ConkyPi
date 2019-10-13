#!/bin/bash
set +e
cd /home/alexsson/Dropbox/ConkyPi/Pictures/
not_empty_jpg=`find . -name "*.jpg"`
if [ ! -z "$not_empty_jpg" ]
then
  mogrify -format png *.jpg && rm *.jpg
fi

new_pics=`find . -not -path '*/\.*' -type f ! -name "*resized.png"`
if [ ! -z "$new_pics" ]
then
  /usr/bin/ls | grep -v '\_resized.png' | xargs mogrify -resize 70% && rm *~
  for file in $(/usr/bin/ls | grep -v '\_resized.png'); do mv $file ${file//.png/}_resized.png ; done && cp *_resized.png .show_pics/
fi
