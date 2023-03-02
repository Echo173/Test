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
max_spd = 6

aim_dir = 0
fric = 0

//Systems
move_stun_timer = 0

//Stats
hp_max = 100
hp = hp_max

mana_max = 100
mana_recharge = 50/60
mana = mana_max
mana_cost = 10 //Total cost to cast one spell

bullet_speed = 6
bullet_range = 80

bullet_cooldown = 12
bullet_cooldown_timer = 0

//Graphics
player_color = make_color_rgb(87, 207, 23)

//Additional Objects
var _bar = instance_create_layer(x, y, "Bars", obj_player_bar_display)
_bar.my_player = id
