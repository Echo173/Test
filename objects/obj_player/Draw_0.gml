shader_set(shd_black)
draw_sprite_ext(sprite_index,image_index,x + 1,y + 8,image_xscale,image_yscale,image_angle,image_blend,0.25)
shader_reset();
	
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,player_color,1)
	