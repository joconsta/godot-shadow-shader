extends ColorRect

const SHADER = preload("res://rect_shadow.shader")

export var corner_radius : int = 0
export var shadow_size : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
    var m = ShaderMaterial.new()
    m.shader = SHADER
    set_material(m)

    m.set_shader_param("rect_position", rect_position)
    m.set_shader_param("rect_end", rect_position + rect_size)
    m.set_shader_param("rect_corner_radius", corner_radius)
    m.set_shader_param("shadow_size", shadow_size)
