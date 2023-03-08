//Switch based on gamestate
switch (gamestate) {
	
	case GAMESTATE.UPGRADE:
		
		//Init Upgrade Screen
		if (upgrade_state_init = 0) {
			
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
