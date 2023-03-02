//Player Inputs
key_thrust = mouse_check_button(mb_left)
key_shoot = mouse_check_button(mb_right) || keyboard_check(vk_space)

//MoveStun
if (move_stun_timer > 0) {
	key_thrust = 0
}
move_stun_timer -= 1

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
	animstate = ANIMSTATE.GROUND
}
if (avg_spd >= min_spd) {
	land_init = 0
	if (animstate = ANIMSTATE.AIR)
	{
		animstate_change_timer += 1
		if (animstate_change_timer > 10)
		{
			animstate = ANIMSTATE.LOW_AIR
		}
	}
	else
	{
		animstate = ANIMSTATE.LOW_AIR
	}
}
if (avg_spd > 3) {
	animstate = ANIMSTATE.AIR
	animstate_change_timer = 0
	
	land_init = 0
}

//Set Sprites
switch (animstate) {
	case ANIMSTATE.GROUND:
		sprite_index = spr_player_ground
		break;
	case ANIMSTATE.LOW_AIR:
		sprite_index = spr_player_low_air	
		break;
	case ANIMSTATE.AIR:
		sprite_index = spr_player_air	
		break;
}

//FX -----------------------------------------------------------------------------------------
//Trail Effects
if (key_thrust)
{
	for (var ii = 0; ii < 1 + floor(avg_spd/6); ii += 1) {
		xx = x - lengthdir_x(6,aim_dir) + lengthdir_x(4 * ii,mdir)
		yy = y - lengthdir_y(6,aim_dir) + lengthdir_y(4 * ii,mdir)
	
		t = instance_create_layer(xx,yy,"BottomFX",obj_player_thrust_fx)
		t.dir = mdir
		t.spd = avg_spd/4
		t.image_angle = mdir
	}
}

///Collisions -----------------------------------------------------------------------------------------
//Set the stun amount
var stun_duration = 45 * (avg_spd/max_spd)
var _shake_mag = 4 * (avg_spd/max_spd)

//X Collision
if (xspd != 0)
{
	if (place_meeting(x + xspd,y,obj_collision))
	{
		if (xspd > 0) {
			x = floor(x)
		} else {
			x = ceil(x)
		}
		
		while (!place_meeting(x + sign(xspd),y,obj_collision))
		{
			x += sign(xspd)	
		}
		
		xspd *= -0.75
		move_stun_timer = stun_duration
		camera_shake(_shake_mag, _shake_mag/15, -1)
	}
}
x += xspd

//YCollision
if (yspd != 0)
{
	if (place_meeting(x,y + yspd,obj_collision))
	{
		if (yspd > 0) {
			y = floor(y)
		} else {
			y = ceil(y)
		}
		
		while (!place_meeting(x,y + sign(yspd),obj_collision))
		{
			y += sign(yspd)	
		}
		
		yspd *= -0.75
		move_stun_timer = stun_duration
		camera_shake(_shake_mag, _shake_mag/15, -1)
	}
}
y += yspd

//Shoot ----------------------------------------------------------------------------------------------
if (bullet_cooldown_timer <= 0) {
	if (mana > mana_cost) {
		if (key_shoot) {
			bullet_cooldown_timer = bullet_cooldown
		
			mana -= mana_cost
		
			var _buffer_length = 16
			var _b = instance_create_layer(x + lengthdir_x(_buffer_length, aim_dir), y + lengthdir_y(_buffer_length, aim_dir), "Bullets", obj_bullet)
		
			var _xs = lengthdir_x(bullet_speed,aim_dir)
			var _ys = lengthdir_y(bullet_speed,aim_dir)
		
			_b.spd = point_distance(0,0,_xs + xspd, _ys + yspd)
			_b.dir = aim_dir
			_b.timer = bullet_range/bullet_speed
		
			_b.bullet_color = player_color
		
			_b.owner = id
		
			_b.image_angle = _b.dir
		}
		else
		{
			mana += mana_recharge
		}
	}
	else
	{
		mana += mana_recharge
	}
	mana = min(mana,mana_max)
}
bullet_cooldown_timer -= 1
