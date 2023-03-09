//Player Inputs
key_thrust = mouse_check_button(mb_left)
key_shoot = mouse_check_button(mb_right)
key_dash =  keyboard_check_pressed(vk_space)

if (gamestate != GAMESTATE.COMBAT) {
	key_thrust = 0
	key_shoot = 0
	key_dash = 0
}

//MoveStun
if (move_stun_timer > 0) {
	key_thrust = 0
	
	//Buffer Dash Input
	if (key_dash = 1) {
		key_dash = 0
		key_dash_buffer = 1
	}
}
else
{
	if (key_dash_buffer = 1) {
		key_dash_buffer = 0
		key_dash = 1
	}
}
move_stun_timer -= 1

//Take Damage (only when not dashing)
if (dash_immune_duration_timer <= 0) {
	check_for_damage_collision();
}
else
{
	//Stop the player from shooting during a dodge
	key_shoot = 0
}
dash_immune_duration_timer -= 1

//Check for death
if (hp <= 0) {
	instance_destroy();	
}

///Movement -------------------------------------------------------------------------------------------
//Get the direction of the mouse
goto_dir = point_direction(x,y,mouse_x,mouse_y)

//Rotate the player towards the mouse (rotation speed is slower the faster the player is moving)
avg_spd = max(abs(xspd),abs(yspd))
aim_dir += angle_difference(goto_dir,aim_dir)/(15 - (12 * ((0.6 - (avg_spd/max_spd)) + (0.4 * key_thrust))))

//Dash -------------------------------------------------------------------------------------------
if (key_dash) {
	if (dash_cooldown_timer <= 0) {
		
		dash_cooldown_timer = dash_cooldown
	
		dash_immune_duration_timer = dash_immune_duration
		dash_thrust_duration_timer = dash_thrust_duration
	
		xspd += lengthdir_x(dash_boost, aim_dir)
		yspd += lengthdir_y(dash_boost, aim_dir)
	}
	else
	{
		//Buffer Dash input
		if (dash_cooldown_timer <= 12) {
			key_dash_buffer = 1
		}
	}
}
dash_cooldown_timer -= 1

//Apply Dash Force
if (dash_thrust_duration_timer > 0) {
	
	xspd += lengthdir_x(dash_thrust, aim_dir)
	yspd += lengthdir_y(dash_thrust, aim_dir)
}
dash_thrust_duration_timer -= 1

//Set thrust (could be changed with power ups)
thrust = max_spd/25

//Apply Thrust
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

//Set movement vars relative to the direction the player is currently moving (mdir)
var mdir = point_direction(0,0,xspd,yspd)
var xfric = abs(fric * lengthdir_x(1,mdir))
var yfric = abs(fric * lengthdir_y(1,mdir))
var xmax = abs(max_spd * lengthdir_x(1,mdir))
var ymax = abs(max_spd * lengthdir_y(1,mdir))
var xmax_fric = abs(thrust * 2 * lengthdir_x(1,mdir))
var ymax_fric = abs(thrust * 2 * lengthdir_y(1,mdir))

//Apply Friction
xspd = approach(xspd,0,xfric)
yspd = approach(yspd,0,yfric)

//Clamp player to max_spd
//xspd = clamp(xspd,-xmax, xmax)
//yspd = clamp(yspd,-ymax, ymax)

//Apply extra friction when player moves faster then max spd
if (xspd >= xmax) xspd = approach(xspd,xmax,xmax_fric)
if (xspd <= -xmax) xspd = approach(xspd,-xmax,xmax_fric)

if (yspd >= ymax) yspd = approach(yspd,ymax,ymax_fric)
if (yspd <= -ymax) yspd = approach(yspd,-ymax,ymax_fric)

///Animation & State Update -----------------------------------------------------------------------------------------
animate_player();

//Set cape image speed (faster when moving fast)
image_speed = 0.5 + (2 * (avg_spd/20))

//FX -----------------------------------------------------------------------------------------
//Trail Effects
if (key_thrust)
{
	for (var ii = 0; ii < 1 + floor(avg_spd/24); ii += 1) {
		xx = x - lengthdir_x(24,aim_dir) + lengthdir_x(16 * ii,mdir)
		yy = y - lengthdir_y(24,aim_dir) + lengthdir_y(16 * ii,mdir)
	
		t = instance_create_layer(xx,yy,"FX_Bottom",obj_player_thrust_fx)
		t.dir = mdir
		t.spd = avg_spd/4
		t.image_angle = mdir
	}
}

///Collisions -----------------------------------------------------------------------------------------
//Set the stun amount
var stun_duration = 45 * (avg_spd/max_spd)
var _shake_mag = 16 * (avg_spd/max_spd)

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
		
			var _buffer_length = 64
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
