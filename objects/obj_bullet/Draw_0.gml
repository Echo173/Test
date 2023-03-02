switch (sprite_index) {
	case spr_bullet_outline:
		draw_sprite_ext(spr_bullet_color,image_index,x,y,image_xscale,image_yscale,image_angle,bullet_color,1)
		draw_self();
		break;
	case spr_bullet_end_outline:
		draw_sprite_ext(spr_bullet_end_color,image_index,x,y,image_xscale,image_yscale,image_angle,bullet_color,1)
		draw_self();
		break;
}

if (global.show_hitboxes = true) {
	if (can_deal_damage = true) {
		draw_sprite_ext(spr_bullet_collision,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.75)
	}
}