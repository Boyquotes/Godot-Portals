shader_type spatial;
render_mode world_vertex_coords, depth_draw_alpha_prepass, cull_disabled;

uniform bool enabled = false;

uniform vec3 slice_normal;
uniform vec3 slice_centre;

uniform vec4 color : hint_color;

varying vec3 world_pos;

void vertex () {
	world_pos = VERTEX;
}

void fragment () {
	if (enabled && dot(slice_normal, world_pos - slice_centre) > 0f) {
		discard;
	}
	
	ALBEDO = color.rgb;
}