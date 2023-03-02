//Draw Shadow
shader_set(shd_black)
draw_sprite_ext(sprite_index,image_index,x + 1,y + 8,image_xscale,image_yscale,image_angle,image_blend,0.25)
shader_reset();

//Draw Player
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,player_color,1)

//Draw hitFlash
if (hit_flash_alpha > 0) {
	
	shader_set(shd_white)
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,hit_flash_alpha)
	shader_reset();
	
	hit_flash_alpha -= hit_flash_alpha_dec
}

//Draw hitbox
//draw_circle(x,y,hitbox_radius,true)