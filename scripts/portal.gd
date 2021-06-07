#tool
extends MeshInstance

export(NodePath) var oppositePortalPath
onready var oppositePortal = get_node(oppositePortalPath)

export(NodePath) var playerCameraPath
onready var playerCamera = get_node(playerCameraPath)

onready var viewport = self.get_node("Viewport")
onready var camera = self.get_node("Viewport/Camera")

func _ready():
	self.get_surface_material(0).set_shader_param("view_texture", oppositePortal.get_node("Viewport").get_texture())
	return

func _process(_delta):
	self.get_node("Viewport").size = Vector2(get_viewport().size.x, get_viewport().size.y)
	
	# Set camera position to match players view through opposite portal
	var trans = oppositePortal.global_transform.inverse() * playerCamera.global_transform
	trans = trans.rotated(Vector3(0, 1, 0), PI)
	camera.global_transform = (self.global_transform * trans)
	
	#var offset = to_local(camera.global_transform.origin)
	#camera.frustum_offset = Vector2(-offset.x, -offset.y)
	#camera.set_frustum(4, Vector2(-offset.x, -offset.y), offset.length()*1, 1000.0)
	
	return
