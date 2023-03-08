//Init Lobby Vars
lobby_init = false

trigger_game_start = false

globalvar user_index;
user_index = -1

globalvar lobby_size;
lobby_size = 0;

globalvar rounds_to_win;
rounds_to_win = 3;

globalvar arena_selected;
arena_selected = rm_arena_1

new_player_queue = ds_queue_create(); //This may be redundant, pls remove if its unnecessary and just call add_player_to_lobby() instead

//Init player data variable
globalvar player_data;

enum PDATA {
	CONNECTED = 0, //Boolean of if the player is still connected to this lobby
	COLOR_INDEX = 1, //The index (1 through 10) of the players selected color
	HEAD_INDEX = 2, //The index of the players selected head type (just 1 exists right now)
	USERNAME = 3, //Players Username
	SPELL = 4, //Current Spell equiped --------- everything below this doesn't get used until players are in the game
	MODS = 5, //List of Mods equiped
	GEAR = 6, //List of gear equiped
	DAMAGE = 7, //Total damage the player has delt this game
	KILLS = 8, //Total kills the player has gotten this game
	TIME_ALIVE = 9, //Total time the player has been alive this game
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
	player_data[_user_index,PDATA.USERNAME] = "PLAYER " + string(_user_index)
	
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
	
	//Reorder player_data array to remove the user that has disconnected (shuffle everything down 1)
	for (var ii = _user_index; ii <= lobby_size - 1; ii += 1) {
		player_data[ii, PDATA.CONNECTED] = player_data[ii + 1, PDATA.CONNECTED]
		player_data[ii, PDATA.COLOR_INDEX] = player_data[ii + 1, PDATA.COLOR_INDEX]
		player_data[ii, PDATA.HEAD_INDEX] = player_data[ii + 1, PDATA.HEAD_INDEX]
		player_data[ii, PDATA.USERNAME] = player_data[ii + 1, PDATA.USERNAME]
	}
	
	if (user_index > _user_index) {
		user_index -= 1
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