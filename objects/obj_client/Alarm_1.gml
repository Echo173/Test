/// @description Timeout
//
// This timer will execute every __refresh_ping_time 
// to resend the ping packet to refresh server ping time

// Check if not disconnected
if connection != CONNECTION_MAP[? "disconnected"] {
	// Update connection
	connection = CONNECTION_MAP[? "connection lost"]

	// Set in_lobby to false
	// in_lobby = false
	
	// Set host to false
	// LOBBY_DATA[? "host"] = false

	// Destroy socket
	network_destroy(sock)
	
	obj_chat.chat("[yellow]connection lost")
}