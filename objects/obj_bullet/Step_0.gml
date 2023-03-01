//Stop the bullet once the timer has run out
if (timer <= 0) {
	//Set Friction
	var mdir = point_direction(0,0,xspd,yspd)
	var xfric = abs(fric * lengthdir_x(1,mdir))
	var yfric = abs(fric * lengthdir_y(1,mdir))
	
	//Apply Friction
	xspd = approach(xspd,0,xfric)
	yspd = approach(yspd,0,yfric)
	
	//Set image Speed
	image_speed = 1
}
timer -= 1

//Clamp bullet to max speed (only needed for tracking bullets)
if (max_spd != -1) {
	var xmax = abs(max_spd * lengthdir_x(1,mdir))
	var ymax = abs(max_spd * lengthdir_y(1,mdir))

	xspd = clamp(xspd,-xmax, xmax)
	yspd = clamp(yspd,-ymax, ymax)
}

//Move this object
x += xspd
y += yspd

//Destroy the bullet opon contact with a wall
if (place_meeting(x,y,obj_collision)) {
	instance_destroy();
}

//Rotate Sprite
image_angle = point_direction(0,0,xspd,yspd)