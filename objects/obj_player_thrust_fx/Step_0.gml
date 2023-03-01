//x += lengthdir_x(spd,dir - 180)
//y += lengthdir_y(spd,dir - 180)

image_angle = dir

spd = approach(spd,0,0.05)

image_xscale = size
image_yscale = size

size -= 0.01

if (size <= 0) instance_destroy();