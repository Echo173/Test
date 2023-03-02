// Draw lobby data template
draw_text(display_get_gui_width()-100, 0, "ID: " + LOBBY_MAP[? "id"])
draw_text(display_get_gui_width()-100, 10, "NAME: " + LOBBY_MAP[? "name"])
draw_text(display_get_gui_width()-100, 20, string("PLAYERS: {0} / {1}", LOBBY_MAP[? "cur_players"], LOBBY_MAP[? "max_players"]))
for(var i=0;i<array_length(lobby_players);i++) {
	draw_text(display_get_gui_width()-100, 30+(10+i), lobby_players[i].username)
}