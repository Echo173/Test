//Animations
function animate_player(_animstate) {
	//Set Sprites
	switch (_animstate) {
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
