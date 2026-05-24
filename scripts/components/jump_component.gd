extends Node
class_name JumpComponent

@export var gravity := 1800.0
@export var jump_force := 620.0
@export var super_jump_min_charge := 0.20
@export var super_jump_force := 980.0
@export var body_slam_speed := 1200.0

func get_gravity() -> float:
	return gravity

func get_jump_velocity() -> float:
	return -jump_force

func can_super_jump(charge_time: float) -> bool:
	return charge_time >= super_jump_min_charge

func get_super_jump_velocity() -> float:
	return -super_jump_force

func get_body_slam_velocity() -> float:
	return body_slam_speed
