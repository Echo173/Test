/// @desc setup and connecting

// ----- Network -----

xsrv = "Ni50Y3AuZXUubmdyb2suaW86MTkxOTY="
sock = network_create_socket(network_socket_tcp)

// ----- Data maps -----

CLIENT_MAP = ds_map_create()
ds_map_add(CLIENT_MAP, "uuid",						"")
ds_map_add(CLIENT_MAP, "username",					"")
ds_map_add(CLIENT_MAP, "ping",						noone)
ds_map_add(CLIENT_MAP, "version",					"DEV")

CONNECTION_MAP = ds_map_create()
ds_map_add(CONNECTION_MAP, "connected",				0)	
ds_map_add(CONNECTION_MAP, "connection lost",		1)
ds_map_add(CONNECTION_MAP, "connecting",			2)
ds_map_add(CONNECTION_MAP, "connection failed",		3)
ds_map_add(CONNECTION_MAP, "disconnected",			4)

INSTRUCTION_MAP = ds_map_create()
ds_map_add(INSTRUCTION_MAP, "ping",					0)
ds_map_add(INSTRUCTION_MAP, "client_info",			1)

// ----- Timers -----

__refresh_ping_time		= 5         	// Time to refresh ping to server (in seconds)
__current_ping_time		= 0				// Current calculated ping time
__connect_tries			= 5				// The amount of max connection retries connection to server
__current_tries			= 0				// Current retry attempts
__packet_timeout		= 20        	// Timer for calculating timeout

// ----- Functions -----

function connect() {
	// Parse host
	var host = string_split(base64_decode(xsrv),":")[0]
	
	// Parse port
	var port = string_split(base64_decode(xsrv),":")[1]
	
	// Connect to server (non_blocking_connect)
	network_connect_raw_async(sock, host, port)
	
	// Update connection state
	connection = CONNECTION_MAP[? "connecting"]
}

function disconnect() {
	// Destroy socket
	network_destroy(sock)
	
	// Update connection state
	connection = CONNECTION_MAP[? "disconnected"]
}

function refresh_server_ping() {
	// Create buffer
	var buff = buffer_create(1, buffer_grow, 1)
	
	// Write instruction to buffer
	buffer_write(buff, buffer_u8, INSTRUCTION_MAP[? "ping"])
	
	// Send buffer
	network_send_raw(sock, buff, buffer_get_size(buff))

	// Reset ping time
	__current_ping_time = current_time
	
	// Start timeout
	alarm[1] = __packet_timeout * room_speed
}

// Connect to server
connect()

// Debug
debug = true