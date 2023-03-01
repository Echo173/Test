//Player Inputs
key_thrust = mouse_check_button(mb_left)
key_shoot = mouse_check_button(mb_right) || keyboard_check(vk_space)

///Aim the Player -------------------------------------------------------------------------------
//Get the direction of the mouse
goto_dir = point_direction(x,y,mouse_x,mouse_y)

//Rotate the player towards the mouse (rotation speed is slower the faster the player is moving)
var avg_spd = max(abs(xspd),abs(yspd))
aim_dir += angle_difference(goto_dir,aim_dir)/(15 - (12 * (1 - (avg_spd/max_spd))))

///Apply Thrust ----------------------------------------------------------------------------------------
//Set thrust (could be changed with power ups)
thrust = max_spd/25
if (key_thrust)
{
	//Play thrust sound effect (no sfx yet)
	//if (!audio_is_playing(snd_jet)) audio_play_sound(snd_jet,5,false);
	
	//Apply thrust to x and y speed
	xspd += lengthdir_x(thrust,	aim_dir)
	yspd += lengthdir_y(thrust, aim_dir)
}
else
{
	//Stop thrust sound effect (no sfx yet)
	//if (audio_is_playing(snd_jet)) audio_stop_sound(snd_jet);
}

//Set Friction 
//var extra_fric = 0
//if (!key_thrust) && (avg_spd < 3) {
	
//	//Glide for a longer time at when you're about to touch back down onto the ground
//	extra_fric = (3 - avg_spd)/15
//}
fric = 0.075// + extra_fric

//Set movement vars relative to the direction the player is currently moving (mdir)
var mdir = point_direction(0,0,xspd,yspd)
var xfric = abs(fric * lengthdir_x(1,mdir))
var yfric = abs(fric * lengthdir_y(1,mdir))
var xmax = abs(max_spd * lengthdir_x(1,mdir))
var ymax = abs(max_spd * lengthdir_y(1,mdir))

//Apply Friction
xspd = approach(xspd,0,xfric)
yspd = approach(yspd,0,yfric)

//Clamp player to max_spd
xspd = clamp(xspd,-xmax, xmax)
yspd = clamp(yspd,-ymax, ymax)

///Animation & State Update -----------------------------------------------------------------------------------------
//Rotate the player sprite
image_angle = aim_dir

//Change sprite based on current travel speed
var min_spd = 0.8
if (key_thrust) min_spd = -1

if (avg_spd < min_spd) {
	state = STATE.GROUND
	sprite_index = spr_player_ground
}
if (avg_spd >= min_spd) {
	land_init = 0
	if (state = STATE.AIR)
	{
		state_change_timer += 1
		if (state_change_timer > 10)
		{
			sprite_index = spr_player_low_air
		}
	}
	else
	{
		sprite_index = spr_player_low_air
	}
}
if (avg_spd > 3) {
	state = STATE.AIR
	sprite_index = spr_player_air
	state_change_timer = 0
	
	land_init = 0
}

//Shoot ----------------------------------------------------------------------------------------------
if (bullet_cooldown_timer <= 0) {
	if (key_shoot) {
		bullet_cooldown_timer = bullet_cooldown
		
		var _buffer_length = 12
		var _b = instance_create_layer(x + lengthdir_x(_buffer_length, aim_dir), y + lengthdir_y(_buffer_length, aim_dir), "Bullets", obj_bullet)
		_b.xspd = xspd + lengthdir_x(bullet_speed, aim_dir)
		_b.yspd = yspd + lengthdir_y(bullet_speed, aim_dir)
		_b.image_angle = point_direction(0,0,_b.xspd,_b.yspd)
	}
}
bullet_cooldown_timer -= 1

///Collisions -----------------------------------------------------------------------------------------
//Set the minimum speed that will cause the player to be stunned if they collide with a wall
var stun_min_spd = 4

//X Collision
if (xspd != 0)
{
	if (place_meeting(x + xspd,y,obj_collision))
	{
		while (!place_meeting(x + sign(xspd),y,obj_collision))
		{
			x += sign(xspd)	
		}
		
		//Check to see if the player should be stunned after hitting a wall
		if (state = STATE.AIR) && (avg_spd >= stun_min_spd)
		{
			//Need to Stun the player here
			xspd *= -0.75
		}
		else
		{
			xspd *= -0.75			
		}
	}
}
x += xspd

//YCollision
if (yspd != 0)
{
	if (place_meeting(x,y + yspd,obj_collision))
	{
		while (!place_meeting(x,y + sign(yspd),obj_collision))
		{
			y += sign(yspd)	
		}
		
		//Check to see if the player should be stunned after hitting a wall
		if (state = STATE.AIR) && (avg_spd >= stun_min_spd)
		{
			//Need to Stun the player here
			yspd *= -0.75
		}
		else
		{
			yspd *= -0.75			
		}
	}
}
y += yspd