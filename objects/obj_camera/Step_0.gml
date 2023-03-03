//FULLSCREEN CONTROLLS
if (keyboard_check_pressed(vk_f11)) {
	if (window_get_fullscreen()) {
		window_set_fullscreen(false)
	}
	else
	{
		window_set_fullscreen(true)
	}
}

//Set Camera Vars
var cam_spd = 5

var dir = point_direction(x,y,mouse_x,mouse_y)
var rad = 128
var m = 1

//Follow Target
if (instance_exists(target))
{
	var _ss = 1 + (0.25 * min(1,(target.avg_spd/(target.max_spd * 0.75))))
	view_scale_goto += (_ss - view_scale_goto)/8
	
	var goto_x = target.x + (lengthdir_x(min(rad,point_distance(x,y,mouse_x,mouse_y)), dir) * m)
	var goto_y = target.y + (lengthdir_y(min(rad,point_distance(x,y,mouse_x,mouse_y)), dir) * m)
	
	x += (goto_x - x)/cam_spd
	y += (goto_y - y)/cam_spd
}
else
{
	view_scale_goto = 1
}

//Camera Shake
if (shake_dir = -1)
{
	var sx = irandom_range(-shake_mag,shake_mag)
	var sy = irandom_range(-shake_mag,shake_mag)
}
else
{
	shake_step *= -1
	var sx = lengthdir_x(shake_mag * shake_step,shake_dir)
	var sy = lengthdir_y(shake_mag * shake_step,shake_dir)
}
shake_mag = approach(shake_mag,0,shake_dec)

//Scale Camera
view_scale += (view_scale_goto - view_scale)/8
camera_set_view_size(view_camera,cam_width * view_scale, cam_height * view_scale)

//Move Camera
var width = camera_get_view_width(view_camera[0])
var height = camera_get_view_height(view_camera[0])

camera_set_view_pos(view_camera[0],x - width/2 + sx,y - height/2 + sy)