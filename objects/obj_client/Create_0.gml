/// @desc setup and connecting

// ----- Network -----

wage = "Mi50Y3AuZXUubmdyb2suaW86MTkxMDc="
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

enum INSTRUCTIONS {
	PING			= 0,
	CLIENT_INFO		= 1,
	CHANGE_USERNAME = 2,
	CREATE_LOBBY	= 3,
	LOBBY_UPDATE	= 4,
	LEAVE			= 5,
	JOIN			= 6,
	KICK			= 7,
	KICKED			= 8,
	LOBBY_LIST		= 9,
	CLOSED			= 10,
	DATA			= 11,
	START			= 12,
	CUSTOM_DATA		= 13
}

LOBBY_MAP = ds_map_create()
function init_lobby_map() {
	ds_map_add(LOBBY_MAP, "id",							"")
	ds_map_add(LOBBY_MAP, "name",						"")
	ds_map_add(LOBBY_MAP, "host",						false)
	ds_map_add(LOBBY_MAP, "private",					false)
	ds_map_add(LOBBY_MAP, "cur_players",				noone)
	ds_map_add(LOBBY_MAP, "max_players",				noone)
	ds_map_add(LOBBY_MAP, "in_game",					false)	
}
init_lobby_map()

ERROR_MAP = ds_map_create()
ds_map_add(ERROR_MAP, "change_username",			["Username include special characters", "Username length is invalid", "Can't change username in lobby"])
ds_map_add(ERROR_MAP, "create_lobby",               ["Name include special characters", "Name length is invalid", "Password length is invalid", "Can't create new lobby inside lobby"])
ds_map_add(ERROR_MAP, "join_lobby",					["Can't join lobby in a lobby", "Lobby not found", "Wrong password", "Lobby full"])
ds_map_add(ERROR_MAP, "leave",						["Not in a lobby"])
ds_map_add(ERROR_MAP, "create",						["Not in a lobby", "Not host", "Not enough players to start the game"])

WAGE_HANDLER_MAP = ds_map_create()
ds_map_add(WAGE_HANDLER_MAP, "connect",				wage_handle_connect)
ds_map_add(WAGE_HANDLER_MAP, "connecting",			wage_handle_connecting)
ds_map_add(WAGE_HANDLER_MAP, "connection failed",	wage_handle_connection_failed)
ds_map_add(WAGE_HANDLER_MAP, "connection lost",		wage_handle_connection_lost)
ds_map_add(WAGE_HANDLER_MAP, "disconnect",			wage_handle_disconnect)
ds_map_add(WAGE_HANDLER_MAP, "lobby join",          wage_handle_lobby_join)

LOBBY_HANDLER_MAP = ds_map_create()
ds_map_add(LOBBY_HANDLER_MAP, "join",				lobby_handle_join)
ds_map_add(LOBBY_HANDLER_MAP, "left",				lobby_handle_left)
ds_map_add(LOBBY_HANDLER_MAP, "lost",				lobby_handle_lost)
ds_map_add(LOBBY_HANDLER_MAP, "kick",				lobby_handle_kick)
ds_map_add(LOBBY_HANDLER_MAP, "data",               lobby_handle_data)
ds_map_add(LOBBY_HANDLER_MAP, "tick",				lobby_handle_tick)

DATA = ds_map_create()

// ----- User data -----
	
lobby_users = []

// ----- Timers -----

__refresh_ping_time		= 5         	// Time to refresh ping to server (in seconds)
__current_ping_time		= 0				// Current calculated ping time
__packet_timeout		= 20        	// Timer for calculating timeout (in seconds)
__connect_timeout		= 8				// Time for connecting to server (in seconds)
__server_tick			= 5				// Server tick speed

// ----- Functions -----

function connect() {
	// Parse host
	var host = string_split(base64_decode(wage),":")[0]
	
	// Parse port
	var port = string_split(base64_decode(wage),":")[1]
	
	// Connect to server (non_blocking_connect)
	network_connect_raw_async(sock, host, port)
	
	// Update connection state
	connection = CONNECTION_MAP[? "connecting"]
	
	// Start connect timeout timer
	alarm[2] = __connect_timeout * room_speed
	
	// Execute handler function
	script_execute(WAGE_HANDLER_MAP[? "connecting"])
}

function disconnect() {
	// Destroy socket
	network_destroy(sock)
	
	// Update connection state
	connection = CONNECTION_MAP[? "disconnected"]

	// Execute handler function
	script_execute(WAGE_HANDLER_MAP[? "disconnect"])
}

function refresh_server_ping() {
	// Create buffer
	var buff = buffer_create(1, buffer_grow, 1)
	
	// Write instruction to buffer
	buffer_write(buff, buffer_u8, INSTRUCTIONS.PING)
	
	// Send buffer
	network_send_raw(sock, buff, buffer_get_size(buff))

	// Reset ping time
	__current_ping_time = current_time
	
	// Start timeout
	alarm[1] = __packet_timeout * room_speed
}

function change_username(username="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.CHANGE_USERNAME)
	buffer_write(buff, buffer_string, username)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function create_lobby(name="", password="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.CREATE_LOBBY)
	buffer_write(buff, buffer_string, name)
	buffer_write(buff, buffer_string, password)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function join_lobby(lobby_id="", lobby_password="") {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.JOIN)
	buffer_write(buff, buffer_string, lobby_id)
	buffer_write(buff, buffer_string, lobby_password)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function leave_lobby() {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.LEAVE)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

function send_data(json_data, uuid) {
	/*var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.DATA)
	var data_map = ds_map_create()
	ds_map_add(data_map, "destination", uuid)
	ds_map_add(data_map, "instruction", instruction)
	ds_map_add(data_map, "data",		json_data)
	buffer_write(buff, buffer_string, json_encode(data_map))
	network_send_raw(sock, buff, buffer_get_size(buff))
	*/
	if ds_map_key_exists(DATA, uuid) {
		var data_array = DATA[? uuid]
		ds_list_add(data_array, json_data)
		ds_map_delete(DATA, uuid)
		ds_map_add_list(DATA, uuid, data_array)
	} else {
		var data_array = ds_list_create()
		ds_list_add(data_array, json_data)
		ds_map_add_list(DATA, uuid, data_array)
	}
}

function start_lobby() {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.START)
	network_send_raw(sock, buff, buffer_get_size(buff))
}

// Connect to server
connect()

alarm[3] = 1