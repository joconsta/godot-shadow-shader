extends ColorRect

export var corner_radius : int = 0
export var shadow_size : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
    material.set_shader_param("rect_position", rect_position)
    material.set_shader_param("rect_end", rect_position + rect_size)
    material.set_shader_param("rect_corner_radius", corner_radius)
    material.set_shader_param("shadow_size", shadow_size)
