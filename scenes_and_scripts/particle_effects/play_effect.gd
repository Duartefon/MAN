extends Node3D
class_name ParticleSystemManager

@export var particle_systems:Array[GPUParticles3D]
var await_ps_counter:int
func play():
	
	for ps in particle_systems:
		ps.emitting = true
		ps.finished.connect(_on_ps_finished)
 		
func _on_ps_finished():
	await_ps_counter += 1
	if await_ps_counter == particle_systems.size():
		queue_free()
	
