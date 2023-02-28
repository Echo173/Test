if debug {
	draw_text(0, 0, string("username: {0}\nuuid: {1}\nping: {2}ms\nconnection: {3}\nPress F4 to hide", CLIENT_MAP[? "username"], CLIENT_MAP[? "uuid"], CLIENT_MAP[? "ping"], ds_map_keys_to_array(CONNECTION_MAP)[connection]))
}