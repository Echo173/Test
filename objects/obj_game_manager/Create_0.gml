//This object exsists for each player throughout a single game before being destroyed and re-created for the next game

//Init Spawn Vars
enum GAMESTATE {
	LOAD = 0,
	COMBAT = 1,
	ROOM_CHANGE = 2
}

globalvar gamestate;
gamestate = GAMESTATE.LOAD

spawn_init = false
spawn_offset = 0

lobby_size = 0 //Replace this variables with relevant networking one
load_room = rm_arena_1

for (var ii = 1; ii <= lobby_size; ii += 1) {
	player_loaded[ii] = false //Number Players 1 to 8
}

for (var ii = 1; ii <= lobby_size; ii += 1) {
	player_loaded[ii] = false //Number Players 1 to 8
}