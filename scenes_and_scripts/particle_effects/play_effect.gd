extends Node3D
class_name ParticleSystemManager

@export var particle_systems:Array[GPUParticles3D]
@export var to_delete: bool = false
 
var await_ps_counter:int = 0
func play():
	for ps in particle_systems:
		if ps:
			ps.emitting = true
			ps.finished.connect(_on_ps_finished)
 		
func _on_ps_finished():
	if !to_delete: return
	await_ps_counter += 1
	if await_ps_counter == particle_systems.size() :
			queue_free()
			print("acabei o ps")
func get_raycast():
	return $RayCast3D
 
			
		
			
	
