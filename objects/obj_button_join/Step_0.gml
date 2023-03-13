//Check to see if the mouse is hovering over this button
if (instance_position(mouse_x,mouse_y,id)) {
	goto_scale = 0.75
	
	//If this button is clicked
	if (mouse_check_button_pressed(mb_left)) {
		//[NET] Join a lobby here
		room_goto(rm_lobby)
		obj_client.join_lobby(get_string("id", ""), "")
	}
}
else
{
	goto_scale = 0.66
}

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale