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
ds_map_add(INSTRUCTION_MAP, "change_username",		2)
ds_map_add(INSTRUCTION_MAP, "create_lobby",			3)
ds_map_add(INSTRUCTION_MAP, "leave",				5)
ds_map_add(INSTRUCTION_MAP, "join",					6)
ds_map_add(INSTRUCTION_MAP, "kick",					7)
ds_map_add(INSTRUCTION_MAP, "kicked",				8)		
ds_map_add(INSTRUCTION_MAP, "lobby_list",           9)
ds_map_add(INSTRUCTION_MAP, "closed",               10)

LOBBY_MAP = ds_map_create()
ds_map_add(LOBBY_MAP, "id",							"")
ds_map_add(LOBBY_MAP, "name",						"")
ds_map_add(LOBBY_MAP, "host",					    false)
ds_map_add(LOBBY_MAP, "private",					false)
ds_map_add(LOBBY_MAP, "cur_players",				noone)
ds_map_add(LOBBY_MAP, "max_players",				noone)
ds_map_add(LOBBY_MAP, "in_game",					false)

ERROR_MAP = ds_map_create()
ds_map_add(ERROR_MAP, "change_username",			["Username include special characters", "Username length is invalid", "Can't change username in lobby"])
ds_map_add(ERROR_MAP, "create_lobby",               ["Name include special characters", "Name length is invalid", "Password length is invalid", "Can't create new lobby inside lobby"])
ds_map_add(ERROR_MAP, "join_lobby",					["Can't join lobby in a lobby", "Lobby not found", "Wrong password", "Lobby full"])

// ----- Player data -----
	
lobby_players = []

// ----- Timers -----

__refresh_ping_time		= 5         	// Time to refresh ping to server (in seconds)
__current_ping_time		= 0				// Current calculated ping time
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

	obj_chat.chat("[yellow]Disconnected")
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

function change_username(username="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTION_MAP[? "change_username"])
	buffer_write(buff, buffer_string, username)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function create_lobby(name="", password="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTION_MAP[? "create_lobby"])
	buffer_write(buff, buffer_string, name)
	buffer_write(buff, buffer_string, password)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function join_lobby(lobby_id="", lobby_password="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTION_MAP[? "join"])
	buffer_write(buff, buffer_string, lobby_id)
	buffer_write(buff, buffer_string, lobby_password)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

// Connect to server
connect()
