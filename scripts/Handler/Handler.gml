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
	
	instance_create_layer(room_width/2, room_height/2, "Players", obj_player_actor, {username: user.username, uuid: user.UUID})
}

function lobby_handle_left(host, ind) {
	/// @function				  lobby_handle_left(host, uuid)
	/// @param {bool}    host	  If user is host
	/// @param {real}    ind	  Index in the lobby_users list
	/// @description              This function is called if one user leaves from lobby
	
	// Get user object
	var user = obj_client.lobby_users[ind]
	
	obj_chat.chat(string("[yellow]{0} left the game", user.username))
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
	var data	= buffer_read(buff, buffer_string)
	
	print(origin)
	print(cmd)
	print(data)
}
#endregion