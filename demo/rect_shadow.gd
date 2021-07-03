tool
extends ColorRect

export(int, 1, 20) var corner_radius = 0 setget set_corner_radius, get_corner_radius
export(int, 1, 20) var shadow_size = 2 setget set_shadow_size, get_shadow_size

func _ready():
	# warning-ignore:return_value_discarded
	connect("item_rect_changed", self, "_on_item_rect_changed")
	material.set_shader_param("rect_position", rect_position)
	material.set_shader_param("rect_end", rect_position + rect_size)
	material.set_shader_param("rect_corner_radius", corner_radius)
	material.set_shader_param("shadow_size", shadow_size)

func set_corner_radius(value):
	corner_radius = value
	material.set_shader_param("rect_corner_radius", corner_radius)

func get_corner_radius():
	return corner_radius

func set_shadow_size(value):
	shadow_size = value
	material.set_shader_param("shadow_size", shadow_size)

func get_shadow_size():
	return shadow_size

func _on_item_rect_changed():
	material.set_shader_param("rect_position", rect_position)
	material.set_shader_param("rect_end", rect_position + rect_size)
