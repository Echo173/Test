/// @description Server tick
if (connection == CONNECTION_MAP[? "connected"]) && (LOBBY_MAP[? "id"] != "") {
	script_execute(LOBBY_HANDLER_MAP[? "tick"], CLIENT_MAP[? "uuid"] == LOBBY_MAP[? "host"])
}
alarm[3] = 5