//Set the upgrades Sprite
function upgrade_set_sprite(_index, _type) {
	switch (_type) {
		case UTYPE.SPELL:
			sprite_index = spr_upgrade_spell
			image_index = _index
			break;
		case UTYPE.MOD:
			sprite_index = spr_upgrade_mod
			image_index = _index
			break;
		case UTYPE.GEAR:
			sprite_index = spr_upgrade_gear
			image_index = _index
			break;
	}
}