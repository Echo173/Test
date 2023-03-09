if (init = 0) {
	init = 1	
	upgrade_set_sprite(upgrade_index, upgrade_type)
}

if (is_equipped = false) {
	var _page_buffer = 1920 * obj_game_manager.upgrade_page
	goto_x = (room_width/2 + ((number - 1) * 320)) - _page_buffer
	
	//Check to see if the mouse is hovering over this button
	if (instance_position(mouse_x,mouse_y,id)) && (player_data[user_index, PDATA.UPGRADE_SELECTED] = false) {
		goto_scale = 1.2
	
		//If this button is clicked
		if (mouse_check_button_pressed(mb_left)) {
			//SELECT UPGRADE
			is_selected = true
		}
	}
	else
	{
		goto_scale = 1
	}
	
	if (is_selected = true) {
		
		is_selected = false
		
		player_data[user_index, PDATA.UPGRADE_SELECTED] = true
		obj_game_manager.upgrade_page = 1
			
		switch (upgrade_type) {
				
			case UTYPE.SPELL:
				with (obj_upgrade) {
					if (is_equipped = true) && (upgrade_type = UTYPE.SPELL) {
						instance_destroy();	
					}
				}
					
				reroll_count += 1
				is_equipped = true
				number = 1
					
				player_data[user_index,PDATA.SPELL] = upgrade_index
				break;
					
			case UTYPE.MOD:
				is_equipped = true
				number = ds_list_size(player_data[user_index,PDATA.MODS])
					
				ds_list_add(player_data[user_index,PDATA.MODS], upgrade_index)
				break;
					
			case UTYPE.GEAR:
				is_equipped = true
				number = ds_list_size(player_data[user_index,PDATA.GEAR])
					
				ds_list_add(player_data[user_index,PDATA.GEAR], upgrade_index)
				break;
		}	
	}
}
else
{
	//Set goto position
	switch (upgrade_type) {
		case UTYPE.SPELL:
			base_scale = 1.25
			goto_x = obj_upgrade_spell_bar.goto_x
			goto_y = obj_upgrade_spell_bar.y
			break;
			
		case UTYPE.MOD:
			base_scale = 0.5
			
			var _side;
			if (number mod 2 = 0) {
				_side = 1
			} else {
				_side = -1
			}
			
			var _dist = 256 + (floor(number/2) * 148)
			
			goto_x = obj_upgrade_spell_bar.goto_x + (_dist * _side)
			goto_y = obj_upgrade_spell_bar.y
			break;
			
		case UTYPE.GEAR:
			base_scale = 0.5
			
			var _offset = 156
			var _width = _offset * (ds_list_size(player_data[user_index,PDATA.GEAR]) - 1)
			
			goto_x = obj_upgrade_gear_bar.goto_x - _width/2 + _offset*number
			goto_y = obj_upgrade_gear_bar.y
			break;
	}
	
	//Check to see if the mouse is hovering over this button
	if (instance_position(mouse_x,mouse_y,id)) {
		goto_scale = base_scale * 1.1
	
		//SHOW INFO
	}
	else
	{
		goto_scale = base_scale
	}
}

//Update position and scale
x += (goto_x - x)/spd
y += (goto_y - y)/spd

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale