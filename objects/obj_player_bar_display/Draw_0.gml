//Draw Bars
with (my_player) {
	
	//Bar Vars
	var _bar_width = 48
	var _bar_height = 6
	var _bar_offset = -52
	
	//Draw Hp
	var _hp_max_bar_width = max(_bar_width * (hp_max/100), _bar_width/8)
	var _hp_bar_width = max(0,_hp_max_bar_width * (hp/hp_max))
	draw_sprite_ext(spr_stat_bar, 0, x - _hp_max_bar_width/2, y + _bar_offset, _hp_max_bar_width,_bar_height,0,c_white,0.5)
	draw_sprite_ext(spr_stat_bar, 1, x - _hp_max_bar_width/2, y + _bar_offset, _hp_bar_width,_bar_height,0,c_white,1)
	
	//Draw Mana
	_bar_offset += _bar_height + 2
	
	var _mana_max_bar_width = max(_bar_width * (mana_max/100), _bar_width/8)
	var _mana_bar_width = max(0,_hp_max_bar_width * (mana/mana_max))
	draw_sprite_ext(spr_stat_bar, 0, x - _mana_max_bar_width/2, y + _bar_offset, _mana_max_bar_width,_bar_height,0,c_white,0.5)
	draw_sprite_ext(spr_stat_bar, 2, x - _mana_max_bar_width/2, y + _bar_offset, _mana_bar_width,_bar_height,0,c_white,1)
}

