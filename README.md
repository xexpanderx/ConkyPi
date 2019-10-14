# ConkyPi
![alt tag](https://github.com/xexpanderx/ConkyPi/blob/master/screenshot.png)

ConkyPi for Raspberry Pi4 and external monitor with 900x1440 resolution (vertical)

<b>Requirements</b>

- Overpass font (https://overpassfont.org/)
- pyowm (https://github.com/csparpa/pyowm)
- w3m (http://w3m.sourceforge.net/)
- openweather api-key and membership (https://openweathermap.org/)
- Monitor with 1440x900 resolution used <b> vertically </b>
- moreutils (https://joeyh.name/code/moreutils/)

<b>Install</b>

`sh install.sh`

<b>Configuration</b>

Edit following variables in "settings.lua":

- api_key
- city
- country_code

<b>Start conky inside ~/.conky/ConkyPi</b>

`sh start_conky.sh`
