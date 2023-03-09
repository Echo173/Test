//Check to see if the mouse is hovering over this button
if (instance_position(mouse_x,mouse_y,id)) {
	goto_scale = 1.2
	
	//If this button is clicked
	if (mouse_check_button_pressed(mb_left)) {
		//Leave Lobby
		obj_client.leave_lobby()
		room_goto(rm_main_menu);
	}
}
else
{
	goto_scale = 1
}

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale