extends ColorRect

onready var the_rect_shadow = $Rect/Shadow
onready var the_rounded_rect_shadow = $RoundedRect/Shadow

const corner_radius = 16    # the same as the stylebox of RoundedRect

var total_time : float = 0.0

var angle : float
var z : float
var p : float
var shadow_size : float

func _ready():
    the_rounded_rect_shadow.corner_radius = corner_radius

func _process(delta):
    total_time += 3 * delta
    angle = (total_time / 100) * PI * 2
    z = 1.0 + sin(angle * 4)
    p = (20 * z) / 2
    shadow_size = z * 10

    # scale the shadow's rect in the vertex shader as z increases
    var r = the_rect_shadow.get_rect()
    the_rect_shadow.material.set_shader_param("rect_position", Vector2(-p, -p))
    the_rect_shadow.material.set_shader_param("rect_end", r.size + Vector2(p, p))
    the_rect_shadow.material.set_shader_param("shadow_size", shadow_size)

    r = the_rounded_rect_shadow.get_rect()
    the_rounded_rect_shadow.material.set_shader_param("rect_position", Vector2(-p, -p))
    the_rounded_rect_shadow.material.set_shader_param("rect_end", r.size + Vector2(p, p))
    the_rounded_rect_shadow.material.set_shader_param("shadow_size", shadow_size)
