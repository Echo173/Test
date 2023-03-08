if (obj_game_manager.upgrade_selected = true) {
	goto_y = room_height + 112
}
else
{
	//Check to see if the mouse is hovering over this button
	if (instance_position(mouse_x,mouse_y,id)) {
		goto_scale = 1.1
	
		//If this button is clicked
		if (mouse_check_button_pressed(mb_left)) {
			if (obj_game_manager.upgrade_page = 0) {
				obj_game_manager.upgrade_page = 1
			}
			else
			{
				obj_game_manager.upgrade_page = 0
			}
		}
	}
	else
	{
		goto_scale = 1
	}
}

image_index = obj_game_manager.upgrade_page = 0

y += (goto_y - y)/obj_game_manager.upgrade_menu_spd

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale