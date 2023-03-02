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

bullet_speed = 10
bullet_range = 96

bullet_cooldown = 12
bullet_cooldown_timer = 0

//Graphics
player_color = make_color_rgb(87, 207, 23)

hit_flash_alpha = 0
hit_flash_alpha_dec = 0
function hit_flash(_alpha, _dec) {
	hit_flash_alpha = _alpha
	hit_flash_alpha_dec = _dec
}

//Additional Objects
var _bar = instance_create_layer(x, y, "Bars", obj_player_bar_display)
_bar.my_player = id

//Damage Functions
hitbox_radius = 10
function check_for_damage_collision() {
	if (collision_circle(x,y,hitbox_radius, obj_damage_collision, false, false)) {
		
		var _dlist = ds_list_create();
		collision_circle_list(x,y,hitbox_radius, obj_damage_collision, false, false,_dlist,false)
		
		for (var ii = 0; ii < ds_list_size(_dlist); ii += 1) {
			var _dinst = ds_list_find_value(_dlist,ii)
			
			//Check to make sure the player can be damaged by this bullet
			if (_dinst.can_deal_damage = true) && (_dinst.owner != id) {
				
				//Take Damage
				hit_flash(2, 0.2)
				hp -= _dinst.damage
				
				//Destroy the damage object
				instance_destroy(_dinst);
			}
		}
	}
}
