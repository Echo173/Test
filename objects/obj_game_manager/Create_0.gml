//This object exsists for each player throughout a single game before being destroyed and re-created for the next game

//Init Spawn Vars
enum GAMESTATE {
	UPGRADE = 0,
	COMBAT_INIT = 1,
	COMBAT_COUNTDOWN = 2,
	COMBAT = 3,
}

globalvar gamestate;
gamestate = GAMESTATE.UPGRADE

globalvar reroll_count;
reroll_count = 3

spawn_offset = 0

//Init player Upgrade vars
player_data[user_index, PDATA.SPELL] = 1
player_data[user_index, PDATA.MODS] = ds_list_create();
player_data[user_index, PDATA.GEAR] = ds_list_create();

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

upgrade_timer_seconds_max = 20
upgrade_timer_seconds = 0
upgrade_timer = 0

upgrade_page = 0
upgrade_menu_spd = 5

upgrade_selected = false

enum UTYPE {
	SPELL = PDATA.SPELL,
	MOD = PDATA.MODS,
	GEAR = PDATA.GEAR,
}