//Animations
function animate_player() {
	
	//Rotate the player sprite
	image_angle = aim_dir

	//Change sprite based on current travel speed
	var min_spd = 0.8
	if (key_thrust) min_spd = -1

	if (avg_spd < min_spd) {
		animstate = ANIMSTATE.STOP
	}
	if (avg_spd >= min_spd) {
		land_init = 0
		if (animstate = ANIMSTATE.FAST)
		{
			animstate_change_timer += 1
			if (animstate_change_timer > 10)
			{
				animstate = ANIMSTATE.SLOW
			}
		}
		else
		{
			animstate = ANIMSTATE.SLOW
		}
	}
	if (avg_spd > max_spd/2) {
		animstate = ANIMSTATE.FAST
		animstate_change_timer = 0
	
		land_init = 0
	}
	
	//Set Sprites
	switch (animstate) {
		case ANIMSTATE.STOP:
			sprite_index = spr_player_cape_stop
			head_image_index = 0
			break;
		case ANIMSTATE.SLOW:
			sprite_index = spr_player_cape_slow	
			head_image_index = 1
			break;
		case ANIMSTATE.FAST:
			sprite_index = spr_player_cape_fast	
			head_image_index = 2
			break;
	}

	//Set Head draw vars
	head_offset = head_offset_max * min(1,(avg_spd/max_spd))
	head_x = lengthdir_x(head_offset,aim_dir)
	head_y = lengthdir_y(head_offset,aim_dir)
}
