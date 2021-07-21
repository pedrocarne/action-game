extends Area2D

func is_colliding(): #gets every area that is colliding but it has to be greater than 0
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] #gets the first area that is colliding and ignore the others
		push_vector = area.global_position.direction_to(global_position)#the vector goes from its positiion to player position
		push_vector = push_vector.normalized()
	return push_vector
