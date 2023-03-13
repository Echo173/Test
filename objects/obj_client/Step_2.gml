var keys = ds_map_keys_to_array(DATA)

for(var i=0;i<array_length(keys);i++) {
	var destination = keys[i]
	var data_list = DATA[? keys[i]]
	var data_map = ds_map_create()
	for(var j=0;j<ds_list_size(data_list);j++) {
		ds_map_add(data_map, j, ds_list_find_value(data_list, j))
	}
	var buff = buffer_create(1, buffer_grow, 1)
	buffer_write(buff, buffer_u8, INSTRUCTIONS.DATA)
	buffer_write(buff, buffer_string, destination)
	buffer_write(buff, buffer_string, json_encode(data_map))
	network_send_raw(sock, buff, buffer_get_size(buff))
}

// Clear DATA
ds_map_clear(DATA)