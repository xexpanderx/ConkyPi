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
  for image in $(/usr/bin/ls | grep -v '\_resized.png'); do value=`identify $image | awk '{print $3}' | sed 's/x/\n/g' | sort -n | head -1` ; scale=$(expr $value / 480) ; if [ $scale -eq 0 ] ; then scale=1 ; else : ; fi ;scale=$(expr 100 / $scale) ; mogrify -resize ${scale}% $image ; done
  for file in $(/usr/bin/ls | grep -v '\_resized.png'); do mv $file ${file//.png/}_resized.png ; done && cp *_resized.png .show_pics/
fi
