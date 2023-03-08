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

spawn_offset = 0

//Upgrade Screen Vars
upgrade_state_init = 0

upgrade_timer_seconds_max = 20
upgrade_timer_seconds = 0
upgrade_timer = 0

upgrade_page = 0
upgrade_menu_spd = 5