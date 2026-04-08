extends RigidBody2D

var positionChange = false
var newPosition = Vector2(0, 0)

var axisVelocityChange = false
var newAxisVelocity = Vector2(0, 0)

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if positionChange == true:
		positionChange = false
		set_position(newPosition)
	if axisVelocityChange == true:
		axisVelocityChange = false
		set_axis_velocity(newAxisVelocity)

func change_position(pos):
	newPosition = pos
	positionChange = true

func change_axis_velocity(vel):
	newAxisVelocity = vel
	axisVelocityChange = true
