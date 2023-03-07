image_blend = get_player_color(player_data[index,PDATA.COLOR_INDEX])
draw_self();

draw_sprite(spr_lobby_character_head,0,x,y - 112)

draw_set_font(fnt_menu_lobby)
draw_set_color(c_white)
draw_text(x,y + 350, index)
draw_text(x,y + 400, player_data[index])
draw_set_color(c_black)