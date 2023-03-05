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
					
					// Execute handler function
					script_execute(WAGE_HANDLER_MAP[? "connect"])
				}
			break
			
			case 2: // Change username
				var successful = buffer_read(buff, buffer_bool)
				
				if successful {
					CLIENT_MAP[? "username"] = buffer_read(buff, buffer_string)	
					obj_chat.chat("[lime]username changed successfully")
				} else {
					var error_code = buffer_read(buff, buffer_u8)
					obj_chat.chat("[red]"+string(ERROR_MAP[? "change_username"][error_code]))
				}
			break
			
			case 3: // Create lobby
				var successful = buffer_read(buff, buffer_bool)
				
				if successful {
					LOBBY_MAP[? "host"] = true
					obj_chat.chat("[lime]lobby created successfully")
				} else {
					var error_code = buffer_read(buff, buffer_u8)
					obj_chat.chat("[red]"+string(ERROR_MAP[? "create_lobby"][error_code]))
				}
			break
			
			case 4: // Lobby update
				var lobby_data = json_parse(buffer_read(buff, buffer_string))
				LOBBY_MAP[? "id"]			= lobby_data.id
				LOBBY_MAP[? "name"]			= lobby_data.name
				LOBBY_MAP[? "private"]		= lobby_data.private
				LOBBY_MAP[? "cur_players"]	= lobby_data.players_count
				LOBBY_MAP[? "max_players"]	= lobby_data.max_players
				LOBBY_MAP[? "in_game"]		= lobby_data.status
				LOBBY_MAP[? "host"]			= lobby_data.host
				
				obj_chat.chat("[yellow]ID: [white]" + string(LOBBY_MAP[? "id"]))
				obj_chat.chat("[yellow]ID Copied to clipboard")
				clipboard_set_text(LOBBY_MAP[? "id"])
				
				var player_data = json_parse(lobby_data.players)
				lobby_users = []

				for(var i=0;i<array_length(player_data);i++) {
					print(player_data[i])
					lobby_users[i] = player_data[i]
					
					switch(lobby_users[i].state) {
						case "static":
							// Noting to update
						break
						
						case "join":
							script_execute(LOBBY_HANDLER_MAP[? "join"], (CLIENT_MAP[? "uuid"] == LOBBY_MAP[? "host"]), i)
						break	
					
						case "left":
							script_execute(LOBBY_HANDLER_MAP[? "left"], (CLIENT_MAP[? "uuid"] == LOBBY_MAP[? "host"]), i)
						break
						
						case "kick":
							script_execute(LOBBY_HANDLER_MAP[? "kick"], (CLIENT_MAP[? "uuid"] == LOBBY_MAP[? "host"]), i)
						break
						
						case "lost":
							script_execute(LOBBY_HANDLER_MAP[? "lost"], (CLIENT_MAP[? "uuid"] == LOBBY_MAP[? "host"]), i)
						break
						
					}
				}
			break
			
			case 5: // Leave
				var successful = buffer_read(buff, buffer_bool)
				
				if successful {
					init_lobby_map()
				} else {
					break
				}
			break
			
			case 6: // Join
				var successful = buffer_read(buff, buffer_bool)
				
				if successful {
					LOBBY_MAP[? "host"] = false
				} else {
					var error_code = buffer_read(buff, buffer_u8)
					obj_chat.chat("[red]"+string(ERROR_MAP[? "join_lobby"][error_code]))
				}
			break
			
			case 11: // Data
				
			break
		}
	break
}