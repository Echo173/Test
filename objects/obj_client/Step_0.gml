if instance_exists(obj_player) {
	var data = {"x": obj_player.x, "y": obj_player.y}
	send_data(0, data, LOBBY_MAP[? "host"])
}