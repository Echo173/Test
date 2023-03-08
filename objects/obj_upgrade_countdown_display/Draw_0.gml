draw_set_font(fnt_menu_lobby_title)
draw_set_halign(fa_center)

draw_text(x,y,"SELECT AN UPGRADE\n" + string(obj_game_manager.upgrade_timer_seconds))

draw_set_halign(fa_left)
draw_set_font(fnt_default)