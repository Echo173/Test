//Initialize the game
draw_set_font(fnt_default);

global.show_hitboxes = false

room_goto_next();
randomize();

window_set_size(320*3, 180*3)
window_center()