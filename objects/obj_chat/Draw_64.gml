draw_set_font(chat_font)

// Calculate chat height for background
var lines = 0
for(var i=0;i<ds_list_size(CHAT_LIST);i++) {
	var text = ds_list_find_value(CHAT_LIST, i)[0]
	var line_length = 0
	for(var j=0;j<array_length(text);j++) {
		line_length += string_width(text[j][1])
	}
	print(line_length)
	lines += 1 + floor(line_length div chat_width)
}

// Draw chat background
draw_set_color(c_black)
draw_set_alpha(0.2)
draw_rectangle(x, y, x + chat_width, y + (string_height("|")*lines), false)

// Draw chat messages
var lines = 0
var line_height = string_height("|")
for(var i=0;i<ds_list_size(CHAT_LIST);i++) {
	var text = ds_list_find_value(CHAT_LIST, i)[0]
	var time = ds_list_find_value(CHAT_LIST, i)[1]
	if time - 1 <= 0 {
		ds_list_delete(CHAT_LIST, i)
		draw_set_alpha(0)
	} else {
		ds_list_set(CHAT_LIST, i, [text, time-1])
		draw_set_alpha((time/10)/message_time)
	}
	var line_length = 0
	for(var j=0;j<array_length(text);j++) {
		draw_set_color(text[j][0])
		var msg = text[j][1]
		for(var k=1;k<string_length(msg)+1;k++) {
			var char = string_char_at(msg, k)
			draw_text(x + line_length, (y+2) + (lines * line_height), char)	
			line_length += string_width(char)
			if line_length >= chat_width-5 {
				lines++	
				line_length = 0
			}
		}
	}
	lines++
}
draw_set_alpha(1)
draw_set_font(fnt_default)