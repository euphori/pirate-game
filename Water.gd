tool
extends Sprite




func _process(delta):
	_zoom_changed()

func _zoom_changed():
	material.set_shader_param("y_zoom", get_viewport_transform().get_scale().y)

func _on_Water_item_rect_changed():
	material.set_shader_param("scale", scale)
