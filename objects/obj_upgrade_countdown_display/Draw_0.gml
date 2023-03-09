draw_set_font(fnt_menu_lobby_title)
draw_set_halign(fa_center)

if (player_data[user_index,PDATA.UPGRADE_SELECTED] = false) {
	draw_text(x,y,"SELECT AN UPGRADE\n" + string(obj_game_manager.upgrade_timer_seconds))
}
else
{
	var _n = lobby_size;
	for (var ii = 1; ii <= lobby_size; ii += 1) {
		if (player_data[ii,PDATA.UPGRADE_SELECTED] = true) {
			_n -= 1
		}
	}
	
	var _str = string(_n) + " PLAYERS"
	if (_n = 1) _str = "1 PLAYER"
	
	draw_text(x,y,"UPGRADE SELECTED\n" + "WAITING FOR " + _str)
}

draw_set_halign(fa_left)
draw_set_font(fnt_default)