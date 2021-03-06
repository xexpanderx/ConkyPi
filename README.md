# ConkyPi (EXPERIMENTAL)
![alt tag](https://github.com/xexpanderx/ConkyPi/blob/master/screenshot.png)

ConkyPi for Raspberry Pi4 and external monitor with 900x1440 resolution (vertical)

<b>Requirements and assumptions</b>

- Overpass font (https://overpassfont.org/)
- pyowm (https://github.com/csparpa/pyowm)
- w3m (http://w3m.sourceforge.net/)
- openweather api-key and membership (https://openweathermap.org/)
- Monitor with 1440x900 resolution used <b> vertically </b>
- moreutils (https://joeyh.name/code/moreutils/)
- urw-base35-fonts (https://github.com/ArtifexSoftware/urw-base35-fonts) 


- Dropbox (https://dropbox.com)

- Your Dropbox folder is located at `~/Dropbox`

<b>Install</b>

`sh install.sh <NAMEYOURCONKY> <API-KEY> <YOURCITY> <COUNTRY_CODE>`

Example:

`sh install.sh MyPrivateConkyPi 13a3992someAPIkey2882 Stockholm SE`

<b>Configuration</b>

Place your images inside `~/Dropbox/ConkyPi/<NAMEYOURCONKY>/Pictures`

<b>*** Change lines inside settings.lua where appropriate. Some lines are still hardcoded. ***</b>

<b>Start conky inside ~/.conky/ConkyPi</b>

`sh start_conky.sh`
