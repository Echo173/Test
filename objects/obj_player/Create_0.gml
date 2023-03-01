//Physics
enum ANIMSTATE {
	GROUND = 0,
	LOW_AIR = 1,
	AIR = 2,
}

animstate = ANIMSTATE.GROUND
animstate_change_timer = 0

xspd = 0
yspd = 0
max_spd = 9

aim_dir = 0
fric = 0

//Systems
move_stun_timer = 0

//Stats
bullet_speed = 6
bullet_range = 64

bullet_cooldown = 12
bullet_cooldown_timer = 0

//Graphics
player_color = make_color_rgb(207, 39, 27)
