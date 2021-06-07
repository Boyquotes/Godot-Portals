shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D view_texture : hint_albedo;

void fragment () {
	ALBEDO = texture(view_texture, SCREEN_UV).rgb;
	//ALBEDO = texture(view_texture, vec2(UV.x, 1f - UV.y)).rgb;
}