extends RigidBody

# TODO: Move script to portal area node, should make this scale better

export(NodePath) var PortalAPath
onready var portalA = get_node(PortalAPath)

export(NodePath) var PortalBPath
onready var portalB = get_node(PortalBPath)

var entrySide

var previousSide
var previousPortal

func _ready():
	return

func _process(delta):
	var distA = (portalA.global_transform.origin - self.global_transform.origin).length()
	var distB = (portalB.global_transform.origin - self.global_transform.origin).length()
	
	var closestPortal
	var oppositePortal
	if (distA < distB):
		closestPortal = portalA
		oppositePortal = portalB
	else:
		closestPortal = portalB
		oppositePortal = portalA
		
	var currentSide = sign(closestPortal.to_local(self.global_transform.origin).z)
	
	if closestPortal != previousPortal or currentSide != previousSide:
		entrySide = currentSide

	if closestPortal.get_node("TravelArea").overlaps_body(self):
		var portalNormal = closestPortal.global_transform.basis.z
		$MeshInstance.get_surface_material(0).set_shader_param("slice_centre", closestPortal.global_transform.origin)
		$MeshInstance.get_surface_material(0).set_shader_param("slice_normal", portalNormal * -entrySide)
		$MeshInstance.get_surface_material(0).set_shader_param("enabled", true)
		
		if currentSide != previousSide:
			var trans = closestPortal.global_transform.inverse() * self.global_transform
			trans = trans.rotated(Vector3(0, 1, 0), PI)
			var localVelocity = self.global_transform.basis.xform_inv(self.linear_velocity)
			self.global_transform = (oppositePortal.global_transform * trans)
			self.linear_velocity = self.global_transform.basis.xform(localVelocity)
			
			entrySide = sign(oppositePortal.to_local(self.global_transform.origin).z)
	else:
		$MeshInstance.get_surface_material(0).set_shader_param("enabled", false)
	
	previousPortal = closestPortal
	previousSide = currentSide
	
	return
