//Switch based on gamestate
switch (gamestate) {
	
	case GAMESTATE.UPGRADE:
		//Init Upgrade Screen
		if (upgrade_state_init = 0) {
			upgrade_state_init = 1
			
			upgrade_timer_seconds = upgrade_timer_seconds_max
			upgrade_timer = 0
			
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
				//Spawn player and set vars
				var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Player", obj_player)
					
					
			}
			else
			{
				//Spawn player actor and set vars
				var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Player", obj_player_actor)
					
					
			}
				
		}
		
		gamestate = GAMESTATE.COMBAT_COUNTDOWN
		spawn_offset += 1 //Change which point the player will spawn at each round
		break;
}
