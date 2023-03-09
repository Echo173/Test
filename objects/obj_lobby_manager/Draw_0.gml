//Only Start after lobby has been initialized
if (lobby_init = true) {
	//Draw Lobby Host Title
	draw_set_halign(fa_center)
	draw_set_font(fnt_menu_lobby_title)
	draw_set_color(c_white)

	draw_text(room_width/2, 48, obj_client.LOBBY_MAP[? "name"])

	//Draw lobby code
	var lobby_code = obj_client.LOBBY_MAP[? "id"] //[NET] Replace with lobby code
	draw_set_font(fnt_menu_lobby_code)
	draw_text(room_width/2, room_height - 180, lobby_code)

	draw_set_halign(fa_left)
	draw_set_font(fnt_default)
}
