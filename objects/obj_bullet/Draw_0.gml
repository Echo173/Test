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