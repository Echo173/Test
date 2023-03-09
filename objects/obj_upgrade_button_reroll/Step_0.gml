//Check to see if the mouse is hovering over this button
if (instance_position(mouse_x,mouse_y,id)) && (reroll_count > 0) && (player_data[user_index, PDATA.UPGRADE_SELECTED] = false) {
	goto_scale = 1.1
	
	//If this button is clicked
	if (mouse_check_button_pressed(mb_left)) {
		//Reroll Upgrades
		with (obj_upgrade) {
			if (is_equipped = false) {
				instance_destroy();
			}	
		}
		
		obj_game_manager.upgrade_create_upgrades_init = 0
		reroll_count -= 1
	}
}
else
{
	goto_scale = 1
}

switch (obj_game_manager.upgrade_page) {
	
	case 0:
		goto_x = base_x
		break;
		
	case 1:
		goto_x = base_x - 1920
		break;
}

x += (goto_x - x)/spd

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale