//Update using the network
check_for_damage_collision();

//Check for death
if (hp <= 0) {
	instance_destroy();	
}

//The following variables need to be updated for this function to work properly
//animstate, aim_dir, key_thrust, avg_spd
animate_player();