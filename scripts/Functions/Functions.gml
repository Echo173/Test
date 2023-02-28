//Approach
function approach(value,target_value,spd){
	if (value < target_value)
	{
		value += spd
		if (value > target_value)
		{
			return target_value;
		}
	}
	if (value > target_value)
	{
		value -= spd
		if (value < target_value)
		{
			return target_value;
		}
	}
	return value;
}