//Switch based on gamestate
switch (gamestate) {
	
	case GAMESTATE.INIT:
		if (room = rm_upgrade) {
			gamestate = GAMESTATE.UPGRADE
		}	
		break;
	
	case GAMESTATE.UPGRADE:
		//Init Upgrade Screen
		if (upgrade_state_init = 0) {
			upgrade_state_init = 1
			
			upgrade_timer_seconds = upgrade_timer_seconds_max
			upgrade_timer = 0
			
			upgrade_create_upgrades_init = 0

			upgrade_timer_end_init = 0

			upgrade_page = 0
			
			upgrade_exit_init = 0
			upgrade_exit_timer = 0
			upgrade_exit_start = 0
			
			//Set upgrade selected to false
			player_data[user_index, PDATA.UPGRADE_SELECTED] = false
			
			//Create exisitng Upgrades -------------------
			var _sx = room_width * 1.5
			var _sy = room_height/2
			
			//Spell
			var _u = instance_create_layer(_sx,_sy,"Upgrades",obj_upgrade)
			_u.number = 1
			_u.upgrade_type = UTYPE.SPELL
			_u.upgrade_index = player_data[user_index,PDATA.SPELL]
			_u.is_equipped = true
			
			//Mods
			for (var ii = 0; ii < ds_list_size(player_data[user_index,PDATA.MODS]); ii += 1) {
				var _u = instance_create_layer(_sx,_sy,"Upgrades",obj_upgrade)
				_u.number = ii
				_u.upgrade_type = UTYPE.MOD
				_u.upgrade_index = ds_list_find_value(player_data[user_index,PDATA.MODS], ii)
				_u.is_equipped = true
			}
			
			//Gear
			for (var ii = 0; ii < ds_list_size(player_data[user_index,PDATA.GEAR]); ii += 1) {
				var _u = instance_create_layer(_sx,_sy,"Upgrades",obj_upgrade)
				_u.number = ii
				_u.upgrade_type = UTYPE.GEAR
				_u.upgrade_index = ds_list_find_value(player_data[user_index,PDATA.GEAR], ii)
				_u.is_equipped = true
			}
		}
		
		//Init New Upgrades
		if (upgrade_create_upgrades_init = 0) {
			
			upgrade_create_upgrades_init = 1
			
			for (var ii = 0; ii < 3; ii += 1) {
				//Create upgrade object
				var _u = instance_create_layer(room_width/2,room_height/4 + 64,"Upgrades",obj_upgrade)
				_u.is_equipped = false
				_u.number = ii
				
				//Set upgrades
				_u.upgrade_index = irandom(2)
				_u.upgrade_type = choose(UTYPE.SPELL, UTYPE.MOD, UTYPE.GEAR)
			}
		}
		
		//Countdown
		if (upgrade_timer_seconds > 0) {
			upgrade_timer += 1
			if (upgrade_timer >= 60) {
				upgrade_timer = 0
				upgrade_timer_seconds -= 1
			}
		}
		else
		{
			if (player_data[user_index,PDATA.UPGRADE_SELECTED] = false) {
				if (upgrade_timer_end_init = 0) {
					var _r = irandom(2)
					with (obj_upgrade) {
						if (is_equipped = false) && (number = _r) {
							is_selected = true	
						}
					}	
					upgrade_timer_end_init = 1
				}
			}
		}
		
		//Check to see if everyone has selected their upgrades
		if (upgrade_exit_start = 0) {
			var _all_upgrades_selected = true
			for (var ii = 1; ii <= lobby_size; ii += 1) {
				if (player_data[ii,PDATA.CONNECTED] = true) {
					if (player_data[ii,PDATA.UPGRADE_SELECTED] = false) {
						_all_upgrades_selected = false
						break;
					}
				}
			}
			
			if (_all_upgrades_selected = true) {
				upgrade_exit_start = 1
			}
		}
		else
		{
			//Leave the room
			upgrade_exit_timer += 1
			if (upgrade_exit_timer > 60) {
				room_transition(arena_selected);
				gamestate = GAMESTATE.UPGRADE_EXIT
			}
		}
		break;
		
	case GAMESTATE.UPGRADE_EXIT:
		if (room = arena_selected) {
			gamestate = GAMESTATE.COMBAT_INIT	
		}
		break;
	
	case GAMESTATE.COMBAT_INIT:
		//Spawn players
		for (var ii = 1; ii <= lobby_size; ii += 1) {
				
			//Find the index to match to a spawn point for this player
			var _check_index = ii + spawn_offset
			while (_check_index > 8) _check_index -= 8
				
			//Get the id of that spawn point object
			var _spawn_point_id = noone
			with (obj_spawn_point) {
				if (_check_index = index) {
					_spawn_point_id = id
				}
			}	

			//Spawn the correct player object
			if (ii = user_index) {
				//Spawn this computers player
				var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Players", obj_player)
			}
			else
			{
				//Spawn player actor
				var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Players", obj_player_actor)
			}
			
			_player_inst.player_color = get_player_color(player_data[ii,PDATA.COLOR_INDEX])
		}
		
		spawn_offset += 1 //Change which point the player will spawn at each round
		
		countdown_timer_seconds = 3
		countdown_timer = 0
		
		gamestate = GAMESTATE.COMBAT_COUNTDOWN
		break;
		
	case GAMESTATE.COMBAT_COUNTDOWN:
		countdown_timer += 1
		if (countdown_timer >= 60) {
			countdown_timer = 0
			countdown_timer_seconds -= 1
		}
		
		if (countdown_timer_seconds <= 0) {
			gamestate = GAMESTATE.COMBAT	
		}
		break;
		
	case GAMESTATE.COMBAT:
		//if (instance_number(obj_player) <= 1) {
		//	room_transition(rm_upgrade);
		//	gamestate = GAMESTATE.COMBAT_EXIT
		//}
		break;
		
	case GAMESTATE.COMBAT_EXIT:
		if (room = rm_upgrade) {
			gamestate = GAMESTATE.UPGRADE
			upgrade_state_init = 0
		}
		break;
}

////TEST
//if (keyboard_check_pressed(ord("P"))) {
	
//	//Init player Upgrade vars
//	for (var ii = 1; ii <= lobby_size; ii += 1) {
//		player_data[ii, PDATA.UPGRADE_SELECTED] = true
//	}	
//}