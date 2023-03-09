switch (gamestate) {
	case GAMESTATE.COMBAT_COUNTDOWN:
		var dx = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2
		var dy = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])/2
		
		draw_set_halign(fa_center)
		draw_set_valign(fa_center)
		draw_set_font(fnt_menu_lobby_code)
		draw_set_color(c_white)
		draw_text(dx,dy,string(countdown_timer_seconds))
		draw_set_font(fnt_default)
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		break;
}