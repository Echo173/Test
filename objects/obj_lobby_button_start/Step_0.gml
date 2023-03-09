//Check to see if the mouse is hovering over this button
if (instance_position(mouse_x,mouse_y,id)) {
	goto_scale = 1.2
	
	//If this button is clicked
	if (mouse_check_button_pressed(mb_left)) {
		//Leave Lobby
		//[NET] Brodcast that the game is starting
		obj_client.start_lobby()
		obj_lobby_manager.trigger_game_start = true
	}
}
else
{
	goto_scale = 1
}

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale