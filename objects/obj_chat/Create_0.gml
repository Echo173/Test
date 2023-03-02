// ----- Data maps -----

CHAT_LIST = ds_list_create()

COLOR_MAP = ds_map_create()
ds_map_add(COLOR_MAP, "white",			c_white)
ds_map_add(COLOR_MAP, "red",			c_red)
ds_map_add(COLOR_MAP, "green",			c_green)
ds_map_add(COLOR_MAP, "blue",			c_blue)
ds_map_add(COLOR_MAP, "yellow",			c_yellow)
ds_map_add(COLOR_MAP, "orange",			c_orange)
ds_map_add(COLOR_MAP, "black",			c_black)
ds_map_add(COLOR_MAP, "purple",			c_purple)
ds_map_add(COLOR_MAP, "aqua",			c_aqua)
ds_map_add(COLOR_MAP, "lime",			c_lime)
ds_map_add(COLOR_MAP, "crazy_color",	90)

// ----- Config -----

message_time = 8								// Time to display chat message (in seconds)
chat_width	 = 480								// Chat width in pixels
chat_font	 = fnt_chat							// Font of chat
x			 = 0								// X position of chat
y			 = 0								// Y position of chat
crazy_color  = 0								// Crazy

// ----- Functions -----

function parse_colors(msg="", def="white") {
	/// @function                 parse_colors(msg, def)
	/// @param {string}  msg	  The message to parse
	/// @param {string}  def	  Default color to use
	/// @description              Will parse colors from message
	// This function will return an array with the color values given in the COLOR_MAP with its message
	// Example output: [color, "text", color, "123"]
	// Colors have the following format: [color]Text
	
	var result = []
	msg = (string_starts_with(msg, "[") ? msg : string("[{0}]", def) + msg)
	var matches = string_split(msg, "[")
	for(var i=1;i<array_length(matches);i++) {
		if string_count("]", matches[i]) > 0 {
			var col = string_split(matches[i], "]")
			var color = ds_map_find_value(COLOR_MAP, def)
			for(var j=0;j<ds_map_size(COLOR_MAP);j++) {
				if col[0] == ds_map_keys_to_array(COLOR_MAP)[j] {
					color = ds_map_find_value(COLOR_MAP, ds_map_keys_to_array(COLOR_MAP)[j])
					break
				}
			}
			array_push(result, [color, col[1]])
		} else {
			var color = ds_map_find_value(COLOR_MAP, def)
			array_push(result, [color, "["+matches[i]])
		}
	}
	return(result)
}

function chat(msg="") {
	/// @function                 chat(msg)
	/// @param {string}  msg	  The message to chat
	/// @description              Will create new chat message with message provided

	ds_list_add(CHAT_LIST, [parse_colors(msg), message_time * room_speed])
	print(parse_colors(msg))
}