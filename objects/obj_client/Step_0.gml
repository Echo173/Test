if instance_exists(obj_player) {
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_s16, obj_player.x)
	send_data(LOBBY_MAP[? "host"], buff)
}