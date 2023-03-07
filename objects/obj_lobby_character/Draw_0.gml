image_blend = get_player_color(player_data[index,PDATA.COLOR_INDEX])
draw_self();

draw_sprite(spr_lobby_character_head,0,x,y - 112)

draw_set_font(fnt_menu_lobby)
draw_set_color(c_white)
draw_set_halign(fa_center)
draw_text(x, y + 180, player_data[index,PDATA.USERNAME])
draw_set_halign(fa_left)
draw_set_color(c_black)