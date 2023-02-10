extends Node

var killed_targets = []

func target_killed(target_index):
	if not killed_targets.has(target_index):
		killed_targets.append(target_index)

func is_target_dead(target_index) -> bool:
	return killed_targets.has(target_index)
