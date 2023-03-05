//Set up surface vars (will only have a surface around the camera)
buffer_size = 96

sx = camera_get_view_x(view_camera[0]) - buffer_size/2
sy = camera_get_view_y(view_camera[0]) - buffer_size/2

sw = camera_get_view_width(view_camera[0]) + buffer_size
sh = camera_get_view_height(view_camera[0]) + buffer_size

//Create Surface
if (!surface_exists(shadow_surf)) {
	surface_create(sw,sh);
}

//Check to see if the su needs to be resized
if (surface_get_width(shadow_surf) != sw) {
	surface_resize(shadow_surf, sw, sh)	
}