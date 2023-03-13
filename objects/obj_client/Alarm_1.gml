/// @description Timeout
//
// This timer will execute every __refresh_ping_time 
// to resend the ping packet to refresh server ping time

// Check if not disconnected
if connection != CONNECTION_MAP[? "disconnected"] {
	// Update connection
	connection = CONNECTION_MAP[? "connection lost"]
	
	// Destroy socket
	network_destroy(sock)
	
	// Execute script
	script_execute(WAGE_HANDLER_MAP[? "connection lost"])
}