#region Wage
function wage_handle_connect() {
	/// @function                 wage_handle_connect()
	/// @description              This function is called at connection to wage server
	
	// Info text in chat
	// obj_chat.chat("[yellow]connected")
}

function wage_handle_connecting() {
	/// @function                 wage_handle_connecting()
	/// @description              This function is called on connecting to the wage server
}

function wage_handle_connection_failed() {
	/// @function                 wage_handle_connection_failed()
	/// @description              This function is called if connection to wage server failed
	
	// Info text in chat
	obj_chat.chat("[yellow]connection failed")
}

function wage_handle_connection_lost() {
	/// @function                 wage_handle_connection_lost()
	/// @description              This function is called if connection lost to wage server
	
	// Info text in chat
	obj_chat.chat("[yellow]connection lost")
	
	room_goto(rm_main_menu)
}

function wage_handle_disconnect() {
	/// @function                 wage_handle_disconnect()
	/// @description              This function is called at disconnection to wage server
	
	// Info text in chat
	obj_chat.chat("[yellow]disconnected")
}

function wage_handle_lobby_join() {
	/// @function                 wage_handle_lobby_join()
	/// @description              This function is called if user joins lobby
	
	// Create map with all player objects with uuid in it
	globalvar players;
	players = ds_map_create()
	
	// Add own player to player map
	var player = instance_create_layer(4000, 4000, "Players", obj_player, {username: obj_client.CLIENT_MAP[? "username"], uuid: obj_client.CLIENT_MAP[? "uuid"]})
	ds_map_add(players, player.uuid, player)
}
#endregion

#region Lobby
function lobby_handle_join(host, ind) {
	/// @function                 lobby_handle_join(host, uuid)
	/// @param {bool}	 host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if a new user joins the lobby

	// Get user object
	var user = obj_client.lobby_users[ind]
	
	// Info text in chat
	obj_chat.chat(string("[yellow]{0} joined the game", user.username))
	
	// Create player object with its value
	var player = instance_create_layer(room_width/2, room_height/2, "Players", obj_player_actor, {username: user.username, uuid: user.UUID})
	ds_map_add(players, user.UUID, player)

	// Send all player data to new connected user
	if host {
		for(var i=0;i<instance_number(obj_player);i++) {
			var player = instance_find(obj_player, i)
			var data = {"inst": PACKETS.POSITION, "x": player.x, "y": player.y, "aim_dir": player.aim_dir, "id": player.uuid}
			obj_client.send_data(data, obj_client.lobby_users[ind].UUID)
		}
	}
}

function lobby_handle_left(host, ind) {
	/// @function				  lobby_handle_left(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user leaves the lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	// Info text in chat
	obj_chat.chat(string("[yellow]{0} left the game", user.username))
	
	// Destroy player object and delete player from players map
	with (players[? user.UUID]) do { instance_destroy() }
	ds_map_delete(players, user.UUID)
}

function lobby_handle_lost(host, ind) {
	/// @function				  lobby_handle_lost(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user lost connection to the lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	// Info text in chat
	obj_chat.chat(string("[yellow]{0} connection lost", user.username))
	
	// Destroy player object and delete player from players map
	with (players[? user.UUID]) do { instance_destroy() }
	ds_map_delete(players, user.UUID)
}

function lobby_handle_kick(host, ind) {
	/// @function				  lobby_handle_kick(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user gets kicked from the lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	// Info text in chat
	obj_chat.chat(string("[yellow]{0} kicked by host", user.username))

	// Destroy player object and delete player from players map
	with (players[? user.UUID]) do { instance_destroy() }
	ds_map_delete(players, user.UUID)
}

function lobby_handle_data(host, buff) {
	/// @function				  lobby_handle_data(host, buff)
	/// @param {bool}    host	  If user is host
	/// @param {real}    buff	  Buffer that contains the data
	/// @description              This function is called if client receives data
	
	// Read origin, cmd and data from data buffer
	var origin	= buffer_read(buff, buffer_string)				// The sender of the data (uuid)
	var data	= json_parse(buffer_read(buff, buffer_string))	// The actual data send to the client
	
	// Parse packets from struct
	var packets = variable_struct_get_names(data)
	
	// Create packet enum for instructions
	enum PACKETS {	
		POSITION = 0	
	}
	
	for(var i=0;i<variable_struct_names_count(data);i++) {
		// Get packet from packets
		var packet = variable_struct_get(data, packets[i])
		
		// Switch packet instruction
		switch(packet.inst) {
			case PACKETS.POSITION:
				// Check if player is not user
				if packet.id != obj_client.CLIENT_MAP[? "uuid"] {
					var player = players[? packet.id]
					try {
						player.movex = packet.x
						player.movey = packet.y
						player.aim_dir = packet.aim_dir
					} catch (e) {
						var player = instance_create_layer(room_width/2, room_height/2, "Players", obj_player_actor, {uuid: packet.id})
						ds_map_add(players, packet.id, player)
					}
				}
			break
		}
	}
	
	/*
	// Switch cmd (instruction)
	switch(cmd) {
		case PACKETS.POSITION:
			//print(data.id)
			//print(obj_client.CLIENT_MAP[? "uuid"])
			// Get player reference
			var player = players[? data.id]
			
			if data.id != obj_client.CLIENT_MAP[? "uuid"] {
				if typeof(player) == "ref" {
					// Update player data
					player.movex = data.x
					player.movey = data.y
					player.aim_dir = data.aim_dir
				}
			}
		break
		
		case 1:
			print(data.text)
		break
	}
	*/
}

function lobby_handle_tick(host) {
	/// @function				  lobby_handle_tick(host)
	/// @param {bool}    host	  If user is host
	/// @description              This function is called every server tick
	
	if instance_exists(obj_player) and !host {
		var data = {"inst": PACKETS.POSITION, "x": obj_player.x, "y": obj_player.y, "aim_dir": obj_player.aim_dir, "id": obj_client.CLIENT_MAP[? "uuid"]}
		obj_client.send_data(data, obj_client.LOBBY_MAP[? "host"])
	}
	
	if host {
		for(var i=0;i<instance_number(obj_player);i++) {
			var player = instance_find(obj_player, i)
			var data = {"inst": PACKETS.POSITION, "x": player.x, "y": player.y, "aim_dir": player.aim_dir, "id": player.uuid}
			for(var j=0;j<array_length(obj_client.lobby_users);j++) {
				if obj_client.lobby_users[j].UUID != LOBBY_MAP[? "host"] {
					obj_client.send_data(data, lobby_users[j].UUID)
				}
			}
		}
	}
}
#endregion