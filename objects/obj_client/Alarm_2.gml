/// @desc Connect timeout

if connection != CONNECTION_MAP[? "connected"] && connection != CONNECTION_MAP[? "disconnected"] {
	// Destroy socket
	network_destroy(sock)

	// Refresh connection map
	connection = CONNECTION_MAP[? "connection failed"]

	// Execute handler function
	script_execute(WAGE_HANDLER_MAP[? "connection failed"])
}