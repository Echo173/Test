//Approach
function approach(value,target_value,spd){
	if (value < target_value)
	{
		value += spd
		if (value > target_value)
		{
			return target_value;
		}
	}
	if (value > target_value)
	{
		value -= spd
		if (value < target_value)
		{
			return target_value;
		}
	}
	return value;
}

//Room transition - Is just a fade to black for now but will update to something cooler in the final game
function room_transition(_target_room) {
	var _tt = instance_create_layer(0,0,"Screen",obj_fade_out)
	_tt.target_room = _target_room
}


//Print
function print(msg="") {
	show_debug_message(string(msg))
}

//Get player color
function get_player_color(_color_index) {
	var _col = c_black
	
	switch (_color_index) {
		case 1:
			_col = make_color_rgb(224, 13, 13)
			break;
		case 2:
			_col = make_color_rgb(245, 150, 7)
			break;
		case 3:
			_col = make_color_rgb(255, 244, 84)
			break;
		case 4:
			_col = make_color_rgb(119, 227, 57)
			break;
		case 5:
			_col = make_color_rgb(22, 204, 83)
			break;
		case 6:
			_col = make_color_rgb(26, 222, 240)
			break;
		case 7:
			_col = make_color_rgb(58, 89, 242)
			break;
		case 8:
			_col = make_color_rgb(92, 52, 148)
			break;
		case 9:
			_col = make_color_rgb(242, 141, 217)
			break;
		case 10:
			_col = make_color_rgb(209, 209, 209)
			break;
	}
	
	return _col;
}

/// @param {buffer} buffer
/// @param {int} ?bytesPerRow
/// @returns {string} text representation
function buffer_prettyprint(_buf, _per_row = 20) {
    static _out = buffer_create(16, buffer_grow, 1);
    static _chars = buffer_create(16, buffer_grow, 1);
    buffer_seek(_out, buffer_seek_start, 0);
    buffer_seek(_chars, buffer_seek_start, 0);
    var _size = buffer_get_size(_buf);
    var _tell = buffer_tell(_buf);
    
    // header:
    buffer_write(_out, buffer_text, "buffer(size: ");
    buffer_write(_out, buffer_text, string(_size));
    buffer_write(_out, buffer_text, ", tell: ");
    buffer_write(_out, buffer_text, string(_tell));
    buffer_write(_out, buffer_text, ", type: ");
    switch (buffer_get_type(_buf)) {
        case buffer_fixed:   buffer_write(_out, buffer_text, "buffer_fixed"  ); break;
        case buffer_grow:    buffer_write(_out, buffer_text, "buffer_grow"   ); break;
        case buffer_fast:    buffer_write(_out, buffer_text, "buffer_fast"   ); break;
        case buffer_wrap:    buffer_write(_out, buffer_text, "buffer_wrap"   ); break;
        case buffer_vbuffer: buffer_write(_out, buffer_text, "buffer_vbuffer"); break;
        default: buffer_write(_out, buffer_text, string(buffer_get_type(_buf))); break;
    }
    buffer_write(_out, buffer_text, "):");
    
    for (var i = 0; i < _size; i++) {
        if (i % _per_row == 0) { // row start
            if (i > 0) { // printable chars
                buffer_write(_out, buffer_text, " | ");
                buffer_write(_chars, buffer_u8, 0);
                buffer_seek(_chars, buffer_seek_start, 0);
                buffer_write(_out, buffer_text, buffer_read(_chars, buffer_string));
                buffer_seek(_chars, buffer_seek_start, 0);
            }
            
            buffer_write(_out, buffer_u8, ord("\n"));
            buffer_write(_out, buffer_text, string_format(i, 6, 0));
            buffer_write(_out, buffer_text, " |");
        }
        buffer_write(_out, buffer_u8, i == _tell ? ord(">") : ord(" "));
        var _byte = buffer_peek(_buf, i, buffer_u8);
        
        // write byte if in printable range or an "unknown" symbol otherwise
        if (_byte >= 32 && _byte < 128) {
            buffer_write(_chars, buffer_u8, _byte);
        } else {
            buffer_write(_chars, buffer_text, "·");
        }
        
        // write the hexadecimal presentation:
        var _hex = _byte >> 4;
        buffer_write(_out, buffer_u8, _hex >= 10 ? ord("A") - 10 + _hex : ord("0") + _hex);
        _hex = _byte & 15;
        buffer_write(_out, buffer_u8, _hex >= 10 ? ord("A") - 10 + _hex : ord("0") + _hex);
    }
    
    // last row's spaces and printable chars:
    if (_size % _per_row != 0) {
        repeat (_per_row - (_size % _per_row)) {
            buffer_write(_out, buffer_text, "   ");
        }
    }
    buffer_write(_out, buffer_text, " | ");
    buffer_write(_chars, buffer_u8, 0);
    buffer_seek(_chars, buffer_seek_start, 0);
    buffer_write(_out, buffer_text, buffer_read(_chars, buffer_string));
    
    buffer_write(_out, buffer_u8, 0);
    buffer_seek(_out, buffer_seek_start, 0);
    show_debug_message(buffer_read(_out, buffer_text))
}

//Map key exists
function ds_map_key_exists(map, key) {
	try {
		return(array_contains(ds_map_keys_to_array(map), key))
	} catch (e) {
		return(false)	
	}
}