draw_set_alpha(alpha)
draw_set_color(c_black)

var _buffer_size = 32

var _cx = camera_get_view_x(view_camera[0]) - _buffer_size/2
var _cy = camera_get_view_y(view_camera[0]) - _buffer_size/2

var _cw = camera_get_view_width(view_camera[0]) + _buffer_size
var _ch = camera_get_view_height(view_camera[0]) + _buffer_size

draw_rectangle(_cx,_cy,_cx + _cw, _cy + _ch, false)

draw_set_color(c_white)
draw_set_alpha(1)

alpha -= 0.05
if (alpha <= 0) {
	instance_destroy();	
}