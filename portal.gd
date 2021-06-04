tool
extends MeshInstance

export(NodePath) var oppositePortalPath
onready var oppositePortal = get_node(oppositePortalPath)

export(bool) var cameraMaster = false

func _ready():
	self.get_surface_material(0).set_shader_param("view_texture", oppositePortal.get_node("Viewport").get_texture())
	#self.get_surface_material(0).set_shader_param("view_texture", self.get_node("Viewport").get_texture())
	return

func _process(delta):
	self.get_node("Viewport").size = get_viewport().size
	
	if !cameraMaster:
		var trans: Transform = oppositePortal.global_transform.inverse() * oppositePortal.get_node("CameraHolder").global_transform
		var up := Vector3(0, 1, 0)
		trans = trans.rotated(up, PI)
		self.get_node("CameraHolder").global_transform = self.global_transform * trans
	
	self.get_node("Viewport/Camera").global_transform = self.get_node("CameraHolder").global_transform
	
	return
