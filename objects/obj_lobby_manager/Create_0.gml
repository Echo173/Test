//Init Lobby Vars
lobby_init = false

user_index = -1
lobby_size = 0

new_player_queue = ds_queue_create();

//Init player data variable
globalvar player_data;

enum PDATA {
	CONNECTED = 0, //Boolean of if the player is still connected to this lobby
	COLOR_INDEX = 1, //The index (1 through 10) of the players selected color
	HEAD_INDEX = 2, //The index of the players selected head type (just 1 exists right now)
}

character_id[1] = noone

//Player Joins
function add_player_to_lobby(_user_index) {
	
	//Find a Free Color
	for (var ii = 1; ii <= 10; ii += 1) {
		var _col_index = ii
		var _taken = false
		
		if (lobby_size > 0) {
			for (var ii = 1; ii <= lobby_size; ii += 1) {
				if (player_data[ii,PDATA.COLOR_INDEX] = _col_index) {
					_taken = true
					break;
				}
			}
		}
		
		//If the color is not taken, set the color index
		if (_taken = false) {
			player_data[_user_index,PDATA.COLOR_INDEX] = _col_index
			break;
		}
	}
	
	//Set other player data
	player_data[_user_index,PDATA.HEAD_INDEX] = 1
	player_data[_user_index,PDATA.CONNECTED] = true
	
	//Create the appropriate lobby character object
	character_id[_user_index] = instance_create_layer(room_width/2, 352, "Display", obj_lobby_character)
	character_id[_user_index].index = _user_index
	
	//Update Lobby Size
	lobby_size += 1
}

//Player is no longer connected
function remove_player_from_lobby(_user_index) {
	
	//Delete the appropriate lobby character
	instance_destroy(character_id[_user_index]);
	
	//Reorder player_data array to remove the user that has disconnected
	for (var ii = _user_index; ii <= lobby_size - 1; ii += 1) {
		player_data[ii, PDATA.CONNECTED] = player_data[ii + 1, PDATA.CONNECTED]
		player_data[ii, PDATA.COLOR_INDEX] = player_data[ii + 1, PDATA.COLOR_INDEX]
		player_data[ii, PDATA.HEAD_INDEX] = player_data[ii + 1, PDATA.HEAD_INDEX]
	}
	
	//Update charactrer_id array
	with (obj_lobby_character) {
		if (index > _user_index) {
			index -= 1
			other.character_id[index] = id
		}
	}
	
	//Update lobby size
	lobby_size -= 1
}