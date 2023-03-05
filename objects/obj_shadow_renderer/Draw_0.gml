//Make sure surface exsists
if (!surface_exists(shadow_surf)) {
	show_message(1)
	exit;
}

//Clear Surface
surface_set_target(shadow_surf)
draw_clear_alpha(c_white,0)

//Set Draw Vars
shader_set(shd_black)
var _shadow_offset_x = 4
var _shadow_offset_y = 32

//Set vars that other objs can access
var _x = sx
var _y = sy

var _w = sw
var _h = sh

//Draw Player Shadows
with (obj_player) {
	//Only draw if the obj is within the view
	if (point_in_rectangle(x,y,_x,_y,_x + _w, _y + _h)) {
		draw_sprite_ext(sprite_index,image_index,x + _shadow_offset_x - _x, y + _shadow_offset_y - _y,image_xscale,image_yscale,image_angle,image_blend,1)
		draw_sprite_ext(head_sprite, head_image_index, x + head_x + _shadow_offset_x - _x, y + head_y + _shadow_offset_y - _y, image_xscale, image_yscale, image_angle, image_blend, 1)
	}
}

//Reset Draw Vars
shader_reset();
surface_reset_target();

//Draw Surface
var _shadow_alpha = 0.3
draw_surface_ext(shadow_surf,sx,sy,1,1,0,c_white,_shadow_alpha)



