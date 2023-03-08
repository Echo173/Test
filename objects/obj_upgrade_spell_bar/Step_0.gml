switch (obj_game_manager.upgrade_page) {
	
	case 0:
		goto_x = base_x + 1920
		break;
		
	case 1:
		goto_x = base_x
		break;
}

x += (goto_x - x)/spd