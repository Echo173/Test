if (reroll_count = 0) {
	image_blend = c_dkgray
}

draw_self();

draw_set_font(fnt_menu_lobby_title)
draw_set_halign(fa_center)
draw_set_valign(fa_center)
draw_set_color(c_black)

draw_text(x,y,"REROLL x" + string(reroll_count))

draw_set_valign(fa_top)
draw_set_halign(fa_left)
draw_set_color(c_white)
draw_set_font(fnt_default)