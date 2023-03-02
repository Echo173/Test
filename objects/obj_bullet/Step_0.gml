//Stop the bullet once the timer has run out
if (timer <= 0) {
	
	if (end_init = 0) {
		end_init = 1
		image_index = 0
		sprite_index = spr_bullet_end_outline
	}
	
	//Turn of damage during end animation
	if (image_index > 3) {
		can_deal_damage = false
	}
	spd /= 1.15
}
timer -= 1

//Move this object
x += lengthdir_x(spd,dir)
y += lengthdir_y(spd,dir)

//Destroy the bullet opon contact with a wall
if (place_meeting(x,y,obj_collision)) {
	instance_destroy();
}