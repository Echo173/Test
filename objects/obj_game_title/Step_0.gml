image_xscale = scale
image_yscale = scale

scale += (goto_scale - scale)/5
goto_scale = 0.66 + (0.02 * sin(counter))
counter += pi/120