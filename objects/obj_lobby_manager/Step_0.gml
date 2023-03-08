//[NET] Update player_data array over the network

//[NET] Set the users index below
if (user_index = -1) {
	//[NET] Figure out which user they are (1 through 8) then set user_index to that number
	//If they are user 1, then they are the host
	user_index = 1
}
else
{
	//Init the player in their instance of the lobby
	if (lobby_init = false) {
		lobby_init = true
		
		//[NET] Add any exising players that were already in the lobby - make sure lobby_size is update for this
		for (var ii = 1; ii <= lobby_size; ii += 1) {
			add_player_to_lobby(ii)
		}
		
		add_player_to_lobby(user_index)
		//[NET] Trigger new player init in other lobbies
		//Do this by sending a packet that will trigger the following code in this object on all other computers
		//ds_queue_enqueue(new_player_queue, new_users_index)
	}
}

//Check for new users that need to be added
if (ds_queue_size(new_player_queue) > 0) {
	add_player_to_lobby(ds_queue_dequeue(new_player_queue));
}

//Check to see if any players are no longer connected
for (var ii = 1; ii <= lobby_size; ii += 1) {
	if (player_data[ii,PDATA.CONNECTED] = false) {
		remove_player_from_lobby(ii)
	}
}

//Update lobby character spacing
var _offset = (room_width - 64)/8
var _width = _offset * (lobby_size - 1)

for (var ii = 1; ii <= lobby_size; ii += 1) {
	character_id[ii].goto_x = room_width/2 - _width/2 + _offset*(ii - 1)
}

//Start Game
if (trigger_game_start = true) {
	trigger_game_start = false
	room_goto(rm_arena_1)
	//instance_create_layer(0,0,"Controllers",obj_game_manager)
}	

//For testing add_player_to_lobby() && remove_player_from_lobby() vv
//if (keyboard_check_pressed(vk_space)) {
//	ds_queue_enqueue(new_player_queue, lobby_size + 1)
//}
//if (keyboard_check_pressed(ord("1"))) player_data[1,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("2"))) player_data[2,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("3"))) player_data[3,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("4"))) player_data[4,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("5"))) player_data[5,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("6"))) player_data[6,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("7"))) player_data[7,PDATA.CONNECTED] = false
//if (keyboard_check_pressed(ord("8"))) player_data[8,PDATA.CONNECTED] = false

