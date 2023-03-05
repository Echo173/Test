//Switch based on gamestate
switch (gamestate) {
	case GAMESTATE.LOAD:
	
		//Get a networking object to update the player_loaded variable if their room = load_room

		//Check if all players are loaded before spawning them in
		var _all_players_loaded = true
		for (var ii = 1; ii <= lobby_size; ii += 1) {
			if (player_loaded[ii] = false) {
				_all_players_loaded = false
			}
		}

		//Spawn Players
		if (_all_players_loaded = true) && (spawn_init = false) {
			
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
				
				var _is_local_player = true //Change if this player index is being controlled from this computer
				
				if (_is_local_player = true) {
					//Spawn player and set vars
					var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Player", obj_player)
				}
				else
				{
					//Spawn player actor and set vars
					var _player_inst = instance_create_layer(_spawn_point_id.x, _spawn_point_id.y, "Player", obj_player_actor)
				}
				
			}
			
			spawn_init = true
			spawn_offset += 1 //Change which point the player will spawn at each round
		}
		break;
}
