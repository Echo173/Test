//Draw Player
draw_sprite_ext(sprite_index, image_index, x , y, image_xscale, image_yscale, image_angle, player_color, 1)
draw_sprite_ext(head_sprite, head_image_index, x + head_x, y + head_y, image_xscale, image_yscale, image_angle, c_white, 1)

//Draw Stun
if (move_stun_timer > 0) {
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_black,0.25)
	draw_sprite_ext(head_sprite, head_image_index, x + head_x, y + head_y, image_xscale, image_yscale, image_angle, c_black, 0.25)
}

//TEST Show Dash immune
if (dash_immune_duration_timer > 0) {
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_yellow,0.5)
	draw_sprite_ext(head_sprite, head_image_index, x + head_x, y + head_y, image_xscale, image_yscale, image_angle, c_yellow, 0.5)
}

//Draw hitFlash
if (hit_flash_alpha > 0) {
	
	shader_set(shd_white)
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,hit_flash_alpha)
	draw_sprite_ext(head_sprite, head_image_index, x + head_x, y + head_y, image_xscale, image_yscale, image_angle, c_white, hit_flash_alpha)
	shader_reset();
	
	hit_flash_alpha -= hit_flash_alpha_dec
}

//Draw hitbox
if (global.show_hitboxes = true) {
	draw_circle(x,y,hitbox_radius,true)
}

//draw_text(x,y - 128, avg_spd)