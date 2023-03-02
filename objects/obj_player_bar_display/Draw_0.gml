//Draw Bars
with (my_player) {
	//Draw Hp
	var _hp_max_bar_width = max(12 * (hp_max/100), 2)
	var _hp_bar_width = max(0,_hp_max_bar_width * (hp/hp_max))
	draw_sprite_ext(spr_stat_bar, 0, x - _hp_max_bar_width/2, y - 16, _hp_max_bar_width,1.5,0,c_white,0.5)
	draw_sprite_ext(spr_stat_bar, 1, x - _hp_max_bar_width/2, y - 16, _hp_bar_width,1.5,0,c_white,1)

	//Draw Mana
	var _mana_max_bar_width = max(12 * (mana_max/100), 2)
	var _mana_bar_width = max(0,_hp_max_bar_width * (mana/mana_max))
	draw_sprite_ext(spr_stat_bar, 0, x - _mana_max_bar_width/2, y - 13.5, _mana_max_bar_width,1.5,0,c_white,0.5)
	draw_sprite_ext(spr_stat_bar, 2, x - _mana_max_bar_width/2, y - 13.5, _mana_bar_width,1.5,0,c_white,1)
}

