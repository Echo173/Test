#region Wage
function wage_handle_connect() {
	// This function is called at connection to wage server
	
	// obj_chat.chat("[yellow]connected")
}

function wage_handle_connecting() {
	// This function is called on connecting to the wage server
}

function wage_handle_connection_failed() {
	// This function is called if connection to wage server failed
	
	obj_chat.chat("[yellow]connection failed")
}

function wage_handle_connection_lost() {
	// This function is called if connection lost to wage server
	
	obj_chat.chat("[yellow]connection lost")	
}

function wage_handle_disconnect() {
	// This function is called at disconnection to wage server
	
	obj_chat.chat("[yellow]disconnected")
}

function wage_handle_lobby_join() {
	// This function is called if user joins lobby	
	
	// Create all players in lobby
	for(var i=0;i<array_length(obj_client.lobby_users);i++) {
		// if obj_client.CLIENT_MAP[? "uuid"] != lobby_users[i].UUID {
			var user = lobby_users[i]
			print(user)
			instance_create_layer(4000, 4000, "Players", obj_player_actor, {username: user.username, uuid: user.UUID})
			print("created")
		// }
	}
}
#endregion

#region Lobby
function lobby_handle_join(host, ind) {
	/// @function                 lobby_handle_join(host, uuid)
	/// @param {bool}	 host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user joins the lobby

	// Get user object
	var user = obj_client.lobby_users[ind]
	
	obj_chat.chat(string("[yellow]{0} joined the game", user.username))
	
	// Create player object with its value 
	instance_create_layer(room_width/2, room_height/2, "Players", obj_player_actor, {username: user.username, uuid: user.UUID})

	if host {
		for(var i=0;i<instance_number(obj_player);i++) {
			var p = instance_find(obj_player, i)
			var data = {"x": p.x, "y": p.y}
			obj_client.send_data(PACKETS.POSITION, data, obj_client.lobby_users[i].UUID)
		}
	}
}

function lobby_handle_left(host, ind) {
	/// @function				  lobby_handle_left(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user leaves from lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	obj_chat.chat(string("[yellow]{0} left the game", user.username))
	
	for(var i=0;i<array_length(obj_client.lobby_users);i++) {
		if (obj_client.CLIENT_MAP[? "uuid"] != lobby_users[i].UUID) {
			var user = lobby_users[i]
			if user.state == "left" {
				for(var j=0;j<instance_number(obj_player_actor);j++) {
					var p = instance_find(obj_player_actor, j)
					if p.uuid == user.UUID {
						with (p) { instance_destroy() }
					}
				}
			}
		}
	}
}

function lobby_handle_lost(host, ind) {
	/// @function				  lobby_handle_lost(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user lost connection to lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	obj_chat.chat(string("[yellow]{0} connection lost", user.username))
}

function lobby_handle_kick(host, ind) {
	/// @function				  lobby_handle_kick(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user gets kicked from lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	obj_chat.chat(string("[yellow]{0} kick by host", user.username))
}

function lobby_handle_data(host, buff) {
	// Read sender from buffer
	var origin	= buffer_read(buff, buffer_string)
	var cmd		= buffer_read(buff, buffer_s16)
	var data	= json_parse(buffer_read(buff, buffer_string))
	
	enum PACKETS {
		POSITION = 0	
	}
	
	// if origin != CLIENT_MAP[? "uuid"] {
		// print(origin)
		// print(cmd)
		// print(data)
	// }
	
	switch(cmd) {
		case PACKETS.POSITION:
			for(var i=0;i<instance_number(obj_player_actor);i++) {
				var p = instance_find(obj_player_actor, i)
				if p.uuid == origin {
					p.movex = data.x
					p.movey = data.y
					p.aim_dir = data.aim_dir
				}
			}
		break
	}
}

function lobby_handle_tick(host) {
	if instance_exists(obj_player) {
		var data = {"x": obj_player.x, "y": obj_player.y, "aim_dir": obj_player.aim_dir}
		obj_client.send_data(PACKETS.POSITION, data, obj_client.LOBBY_MAP[? "host"])
	}
}
#endregion