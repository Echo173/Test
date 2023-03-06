if instance_exists(obj_player) {
	var data = {"position": obj_player.x}
	send_data(0, data, LOBBY_MAP[? "host"])
}