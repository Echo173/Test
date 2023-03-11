//Check to see if the mouse is hovering over this button
if (instance_position(mouse_x,mouse_y,id)) {
	goto_scale = 0.75
	
	//If this button is clicked
	if (mouse_check_button_pressed(mb_left)) {
		obj_client.create_lobby("LobbyTest", "")
		room_goto(rm_lobby)
	}
}
else
{
	goto_scale = 0.66
}

scale += (goto_scale - scale)/5
image_xscale = scale
image_yscale = scale