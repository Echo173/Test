//This object exsists for each player throughout a single game before being destroyed and re-created for the next game

//Init Spawn Vars
enum GAMESTATE {
	INIT = 0,
	UPGRADE = 1,
	UPGRADE_EXIT = 2,
	COMBAT_INIT = 3,
	COMBAT_COUNTDOWN = 4,
	COMBAT = 5,
	COMBAT_EXIT = 6,
}

globalvar gamestate;
gamestate = GAMESTATE.INIT

globalvar reroll_count;
reroll_count = 3

spawn_offset = 0

//Init player Upgrade vars
for (var ii = 1; ii <= lobby_size; ii += 1) {
	player_data[ii, PDATA.SPELL] = 0
	player_data[ii, PDATA.MODS] = ds_list_create();
	player_data[ii, PDATA.GEAR] = ds_list_create();

	player_data[ii, PDATA.UPGRADE_SELECTED] = false
}

//TESTING CODE
//ds_list_add(player_data[user_index, PDATA.MODS],irandom(2))
//ds_list_add(player_data[user_index, PDATA.MODS],irandom(2))
//ds_list_add(player_data[user_index, PDATA.MODS],irandom(2))
//ds_list_add(player_data[user_index, PDATA.MODS],irandom(2))

//ds_list_add(player_data[user_index, PDATA.GEAR],irandom(2))
//ds_list_add(player_data[user_index, PDATA.GEAR],irandom(2))
//ds_list_add(player_data[user_index, PDATA.GEAR],irandom(2))
//ds_list_add(player_data[user_index, PDATA.GEAR],irandom(2))

//Upgrade Screen Vars
upgrade_state_init = 0

upgrade_create_upgrades_init = 0

upgrade_timer_seconds_max = upgrade_time_limit
upgrade_timer_seconds = 0
upgrade_timer = 0
upgrade_timer_end_init = 0

upgrade_page = 0
upgrade_menu_spd = 5

upgrade_exit_start = 0
upgrade_exit_init = 0
upgrade_exit_timer = 0

//Game Screen Vars
countdown_timer_seconds = 0
countdown_timer = 0

enum UTYPE {
	SPELL = PDATA.SPELL,
	MOD = PDATA.MODS,
	GEAR = PDATA.GEAR,
}