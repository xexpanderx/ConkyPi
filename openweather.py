#!/usr/bin/env python3
import pyowm
import argparse
import subprocess
from datetime import datetime
from datetime import timezone
from datetime import timedelta
from pyowm import timeutils

def weater_in_future (weather_details,time_now, hours):
    return weather_details.get_weather_at(
        datetime(
                time_now.year,
                time_now.month,
                time_now.day,
                time_now.hour + hours,
                time_now.minute,
                time_now.second))

def process (args):

    owm = pyowm.OWM(args.api_key[0])

    if args.three_hours_forecast:
        weather_details_now = owm.weather_at_place(args.city[0] + ',' + args.ccode[0])
        weather_values_now = weather_details_now.get_weather()
        
        if args.get_temp_c:
            print(round(weather_values_now.get_temperature(unit='celsius')['temp']))
        if args.get_weather_icon:
            print('PNG/' + weather_values_now.get_weather_icon_name() + '.png')

        weather_details = owm.three_hours_forecast(args.city[0]+','+args.ccode[0])
        time_now = datetime.now(timezone.utc)
        for i in range(3, 15, 3):
            weather_values = weater_in_future(weather_details, time_now + timedelta(hours=i), 0)
            if args.get_temp_c:
                print(round(weather_values.get_temperature(unit='celsius')['temp']))
            if args.get_weather_icon:
                print('PNG/'+weather_values.get_weather_icon_name()+'.png')

    else:
        weather_details = owm.weather_at_place(args.city[0] + ',' + args.ccode[0])
        weather_values = weather_details.get_weather()
        if args.get_temp_c:
            print(weather_values.get_temperature(unit='celsius')['temp'])
        if args.get_temp_f:
            print(weather_values.get_temperature(unit='fahrenheit')['temp'])
        if args.get_weather_icon:
            print('PNG/'+weather_values.get_weather_icon_name()+'.png')
        if args.sunrise:
            print(weather_values.get_sunrise_time('iso'))
        if args.sunset:
            print(weather_values.get_sunset_time('iso'))

parser = argparse.ArgumentParser(description='Openweather script.')
parser.add_argument('--api_key',help='OWM API key.',nargs=1,metavar=('[api_key]'), required=True)
parser.add_argument('--city',help='Cityname.',nargs=1,metavar=('[city]'), required=True)
parser.add_argument('--ccode',help='Country code.',nargs=1,metavar=('[code]'), required=True)
parser.add_argument('--get_temp_c',help='Get temperature in Celsius.',action='store_true')
parser.add_argument('--get_temp_f',help='Get temperature in Fahrenheit.',action='store_true')
parser.add_argument('--get_weather_icon',help='Get weekday.',action='store_true')
parser.add_argument('--three_hours_forecast',help='Get three hours forecast.', action='store_true')
parser.add_argument('--sunrise',help='Sunrise time.', action='store_true')
parser.add_argument('--sunset',help='Sunset time.', action='store_true')
args = parser.parse_args()

process(args)
