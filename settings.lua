
-- ###Openweather settings###
api_key = "13aad301dd37412e01c6c3d4abe0b12e"
city = "Uppsala"
country_code = "SE"
-- ###Device settings###
device= "[Device]"
-- ###Colors###
background_color = "#FFFFFF"
weather_background_color = "#2E2E2E"
clock_text_background = "#2E2E2E"
weather_text_background = "#FFFFFF"
temp_text = "#FFFFFF"
circles = "#2E2E2EF"
transparency_background = 1.0
transparency_weather_background = 1.0
transparency_clock_text = 1.0
transparency_weather_icon = 1.0
transparency_weather_text = 1.0
transparency_temp_text = 1.0
transparency_circle = 1.0
--- ###Text file location
text_file = "/home/alexsson/Dropbox/ConkyPi/" .. device .. "/conkypi_text.txt"
hidden_text_file = "/home/alexsson/Dropbox/ConkyPi/" .. device .. "/.tmp/.conkypi_text.txt"
directory = "/home/alexsson/Dropbox/ConkyPi/[Device]"
-- ###Dont change code below###
require 'cairo'
assert(os.setlocale("en_US.utf8", "numeric"))

a = {}
a['Monday'] = 'Måndag'
a['Tuesday'] = "Tisdag"
a['Wednesday'] = "Onsdag"
a['Thursday'] = "Torsdag"
a['Friday'] = "Fredag"
a['Saturday'] = "Lördag"
a['Sunday'] = "Söndag"

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

r_background, g_background, b_background = hex2rgb(background_color)
r_weather_background, g_weather_background, b_weather_background = hex2rgb(weather_background_color)
r_clock_text, g_clock_text, b_clock_text = hex2rgb(clock_text_background)
r_weather_text, g_weather_text, b_weather_text = hex2rgb(weather_text_background)
r_temp_text, g_temp_text, b_temp_text = hex2rgb(temp_text)
r_circles, g_circles, b_circles = hex2rgb(circles)

function fix_text(text)
	if string.len(text) == 1 then
		new_text = "0" .. text
		return new_text
	else
		new_text = text
		return new_text
	end
end

function check_hour(hour)
	if tonumber(hour) >= 24 then
		hour = tonumber(hour) - 24
		return fix_text(tostring(hour))
	else
		return fix_text(tostring(hour))
	end
end

function draw_function(cr)
	local w,h=conky_window.width,conky_window.height

  --Draw backgrounds
			cairo_set_source_rgba(cr,r_background,g_background,b_background,transparency_background)
			cairo_new_path(cr)
			cairo_set_line_width(cr, 2)
			cairo_rectangle(cr,0,0,w,h)
			cairo_fill(cr);
			cairo_set_source_rgba(cr,r_weather_background,g_weather_background,b_weather_background,transparency_weather_background)
			cairo_rectangle(cr,w-200,0,200,h)
			cairo_fill(cr)
			cairo_close_path(cr)

  --Draw clock widget
			--Draw clock
			cairo_new_path(cr)
			cairo_set_source_rgba(cr,r_clock_text,g_clock_text,b_clock_text,transparency_clock_text)
	  	cairo_set_font_size(cr, 78)
  		cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  		time = conky_parse('${exec date +%R}')
			ct_time = cairo_text_extents_t:create()
			cairo_text_extents(cr,time,ct_time)
			cairo_move_to(cr,350-ct_time.width/2,80)
			cairo_show_text(cr,time)
			cairo_close_path(cr)

			--Draw date
			cairo_new_path(cr)
			cairo_set_font_size(cr, 24)
			date = conky_parse('${execi 60 date "+%A, %-e %B, Week %V"}')
			ct_date = cairo_text_extents_t:create()
			cairo_text_extents(cr,date,ct_date)
			cairo_move_to(cr,350-ct_date.width/2,80+ct_time.height)
			cairo_show_text(cr,date)
			cairo_close_path(cr)

			--Draw namesday
			cairo_new_path(cr)
			cairo_set_font_size(cr, 24)
			cairo_select_font_face (cr, "Z003", CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_NORMAL)
			namesday = conky_parse('${execi 60 w3m -dump http://www.namnsdag.nu | sed -n "6p"}')
			ct_namesday = cairo_text_extents_t:create()
			cairo_text_extents(cr,namesday,ct_namesday)
			cairo_move_to(cr,350-ct_namesday.width/2,75+ct_time.height*2)
			cairo_show_text(cr,namesday)
			cairo_close_path(cr)

			--Draw lunch
			cairo_new_path(cr)
			cairo_set_font_size(cr, 24)
			cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
			ct_lunch = cairo_text_extents_t:create()
			cairo_text_extents(cr,"Lunch",ct_lunch)
			cairo_move_to(cr,350-ct_lunch.width/2,75+ct_time.height*3)
			cairo_show_text(cr,"Lunch")
			cairo_move_to(cr,350-ct_lunch.width/2,75+ct_time.height*3+2)
			cairo_rel_line_to (cr, ct_lunch.width+5, 0);
			cairo_stroke(cr)
			cairo_close_path(cr)

			--Draw menu
			cairo_new_path(cr)
			cairo_set_font_size(cr, 18)
			weekday = conky_parse('${execi 60 date +%A}')
			fullmenu = conky_parse('${execi 60 curl -s https://restaurangheat.se/veckans-lunchmeny/ | sed \'s/.*<h3>' .. a[weekday] .. '<\\/h3>//g\' | awk -F \'</div>\' \'{print $1}\' | awk -F\'<h4><strong>\' \'{for(i=2;i<=NF;++i)print $i}\' | sed \'s/<\\/strong><\\/h4><p>.*//g\' | sed \'s/<strong>//g\' | sed \'s/<\\/strong>//g\' | sed \'s/Självklart serverar vi även vår goda bearnaisesås//g\' | sed \'s/<em><\\/p><p><\\/em><\\/h4>//g\' | grep -v -e \'^$\' | tr \'\\n\' \'_\' | sed \'s/<em><\\/em>//g\' | sed \'s/<\\/h4>//g\' | sed \'s/<\\/p><p>//g\'}')
			pos = 1
			for menu in fullmenu:gmatch("([^_]+)") do
				cairo_new_path(cr)
				ct_menu = cairo_text_extents_t:create()
				cairo_text_extents(cr,menu,ct_menu)
				cairo_move_to(cr,350-ct_menu.width/2,75+ct_time.height*3+28*pos+6)
				cairo_show_text(cr,menu)
				cairo_close_path(cr)
				pos = pos + 1
			end
			cairo_close_path(cr)

	--Draw messages
			--Pic of day
				--Get image and show it
			cairo_new_path(cr)
      conky_parse("${execi 1800 " .. directory .. "/Pictures/.commands_pictures.sh }")
			get_image = conky_parse("${execi 300 /usr/bin/ls " .. directory .. "/Pictures/.show_pics/* | shuf -n 1 | xargs -n1 basename}")
			cairo_save(cr)
			cairo_arc (cr, 350, 720, 240, 0, 6.28)
			cairo_clip (cr)
			local image = cairo_image_surface_create_from_png (directory .. "/Pictures/.show_pics/" .. get_image)
			local w_img = cairo_image_surface_get_width (image)
			local h_img = cairo_image_surface_get_height (image)
			cairo_set_source_surface (cr, image,350-w_img/2,480+240-h_img/2)
			cairo_paint_with_alpha (cr, 1.0)
			cairo_surface_destroy (image)
			cairo_restore(cr)
			cairo_close_path(cr)

			--Messages of the day
				--Get text from file
			cairo_new_path(cr)
			conky_parse("${execi 1 fold -s -w50 " .. text_file .. " | sponge " .. hidden_text_file .. "}")
			local f = assert(io.open(hidden_text_file, "rb"))
			local content = f:read("*all")
			f:close()
			lines = 0
			for line in content:gmatch("([^\n]+)") do
				lines = lines + 1
			end
			pos = 120-(10*lines)+10
			for line in content:gmatch("([^\n]+)") do
				cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
				cairo_set_source_rgba(cr,r_clock_text,g_clock_text,b_clock_text,transparency_clock_text)
				cairo_set_font_size(cr, 24)
				ct_message_of_day= cairo_text_extents_t:create()
				cairo_text_extents(cr,line,ct_message_of_day)
				cairo_move_to(cr,350-ct_message_of_day.width/2,480*2+pos)
				cairo_show_text(cr,line)
				pos = pos+ct_message_of_day.height+10
			end
			cairo_close_path(cr)

	--Draw weather
			cairo_new_path(cr)
			cairo_set_source_rgba(cr,r_weather_text, g_weather_text, b_weather_text,transparency_weather_text)
			cairo_set_font_size(cr, 24)
			cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
			ct_weather_text= cairo_text_extents_t:create()
			cairo_text_extents(cr,city,ct_weather_text)
			cairo_move_to(cr,w-100-ct_weather_text.width/2,20+ct_weather_text.height)
			cairo_show_text(cr,city)
			cairo_set_source_rgba(cr,r_weather_background,g_weather_background,b_weather_background,transparency_weather_background)
			image_path = conky_parse("${execi 60 ./openweather.py --api_key " .. api_key .. " --city " .. city .. " --ccode " .. country_code .. " --get_weather_icon --three_hours_forecast}")
			pos=0
			for image in image_path:gmatch("([^\n]+)") do
				cairo_save(cr)
				local image = cairo_image_surface_create_from_png (image)
				local w_img = cairo_image_surface_get_width (image)
				local h_img = cairo_image_surface_get_height (image)
				local scale_factor = 1
				cairo_scale(cr, scale_factor, scale_factor)
				cairo_set_source_surface (cr, image,w*(w/(w*scale_factor))-100*(w/(w*scale_factor))-w_img/2, 80*(h/(h*scale_factor))+pos)
				cairo_paint_with_alpha (cr, 1.0)
				cairo_surface_destroy (image)
				cairo_restore(cr)
				pos = pos+270
			end
			cairo_set_source_rgba(cr,r_weather_text, g_weather_text, b_weather_text,transparency_weather_text)
			temperature = conky_parse("${execi 60 ./openweather.py --api_key " .. api_key .. " --city " .. city .. " --ccode " .. country_code .. " --get_temp_c --three_hours_forecast}")
			pos=0
			number_of_iterations = 1
			for temp in temperature:gmatch("([^\n]+)") do
				cairo_set_font_size(cr, 24)
				cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
				ct_temp= cairo_text_extents_t:create()
				cairo_text_extents(cr,temp .. "˚C",ct_temp)
				cairo_move_to(cr,w-100-ct_temp.width/2,270+ct_temp.height+pos)
				cairo_show_text(cr,temp .. "˚C")
				pos = pos + 270
				number_of_iterations = number_of_iterations + 1
			end
			hour = tonumber(conky_parse('${execi 60 date +%H}'))
			hour = check_hour(hour)
			pos = 0
			for i=1,(number_of_iterations-1) do
				if i == 5 then
					pos = pos-1
				end
				cairo_select_font_face (cr, "Overpass", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
				cairo_set_font_size(cr, 18)
				ct_hour= cairo_text_extents_t:create()
				cairo_text_extents(cr,hour .. ":00",ct_hour)
				cairo_move_to(cr,w-100-ct_hour.width/2,300+ct_hour.height+pos)
				cairo_show_text(cr,tostring(hour) .. ":00")
				hour = check_hour(tonumber(hour)+3)
				pos = pos + 270
			end
			cairo_close_path(cr)

	--Draw system indicators
			cairo_set_source_rgba(cr,r_circles,g_circles,b_circles,transparency_circle)
			cairo_new_path(cr)
			cairo_arc(cr,350-30,h-30,20,0,6.28)
			cairo_fill(cr)
			cairo_close_path(cr)

			cairo_set_source_rgba(cr,r_temp_text,g_temp_text,b_temp_text,transparency_temp_text)
			cairo_new_path(cr)
			cairo_set_font_size(cr, 12)
			ct_temp= cairo_text_extents_t:create()
			cairo_text_extents(cr,"64˚C",ct_temp)
			cairo_move_to(cr,350-ct_temp.width/2-30,h-30+ct_temp.height/2)
			cairo_show_text(cr,"64˚C")
			cairo_close_path(cr)

			cairo_set_source_rgba(cr,r_circles,g_circles,b_circles,transparency_circle)
			cairo_new_path(cr)
			cairo_arc(cr,350+30,h-30,20,0,6.28)
			cairo_fill(cr)
			cairo_close_path(cr)

			cairo_set_source_rgba(cr,r_temp_text,g_temp_text,b_temp_text,transparency_temp_text)
			cairo_new_path(cr)
			cairo_set_font_size(cr, 12)
			ct_temp= cairo_text_extents_t:create()
			cairo_text_extents(cr,"84%",ct_temp)
			cairo_move_to(cr,350-ct_temp.width/2+30,h-30+ct_temp.height/2)
			cairo_show_text(cr,"84%")
			cairo_close_path(cr)
end

function conky_start_widgets()
	local function draw_conky_function(cr)
		draw_function(cr)
	end

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)
	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	-- Check that Conky has been running for at least 5s

	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
