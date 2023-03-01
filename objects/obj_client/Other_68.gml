switch(async_load[? "type"])
{	
	case network_type_data:
		// Read buffer
		var buff = async_load[? "buffer"]
		
		// Buffer seek
		buffer_seek(buff, buffer_seek_start, 0)
		
		// Parse instruction
		var cmd = buffer_read(buff, buffer_u8)
		
		// Switch instruction
		switch(cmd) {
			case 0: // Ping
				// Calculate ping
				CLIENT_MAP[? "ping"] = current_time - __current_ping_time
			
				// Reset ping timer
				alarm[0] = __refresh_ping_time * room_speed
				
				obj_chat.chat("[yellow]ping: [white]" + string(CLIENT_MAP[? "ping"]) + "ms")
			break
			
			case 1: // Client info
				// Check connection status
				if connection != CONNECTION_MAP[? "connected"] {
					// Update connection
					connection = CONNECTION_MAP[? "connected"]	
				
					// Read and parse json data from buffer
					var json_data = json_parse(buffer_read(buff, buffer_string))
					
					// Read uuid from json
					CLIENT_MAP[? "uuid"] = json_data.UUID
				
					// Read username from json
					CLIENT_MAP[? "username"] = json_data.USERNAME
				
					// Check if protocol versions match
					if CLIENT_MAP[? "version"] == json_data.VERSION {
						// Start ping timer
						alarm[0] = 1
					} else {
						// Disconnect
						disconnect()
					}
					
					obj_chat.chat("[yellow]connected")
					obj_chat.chat("[yellow]uuid: [orange]" + string(CLIENT_MAP[? "uuid"]))
					obj_chat.chat("[yellow]username: [orange]" + string(CLIENT_MAP[? "username"]))
					obj_chat.chat("[white]press [purple]F1[white] to change username")
				}
			break
			
			case 2: // Change username
				var successful = buffer_read(buff, buffer_bool)
				
				if successful {
					CLIENT_MAP[? "username"] = buffer_read(buff, buffer_string)	
					obj_chat.chat("[green]username changed successfully")
				} else {
					var error_code = buffer_read(buff, buffer_u8)
					obj_chat.chat("[red]"+string(ERROR_MAP[? "change_username"][error_code]))
				}
			break
		}
	break
}