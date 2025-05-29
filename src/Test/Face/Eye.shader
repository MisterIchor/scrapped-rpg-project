shader_type canvas_item;

uniform float blink_percentage = 0.0;



void fragment() {
	COLOR = texture(TEXTURE, UV);
//	COLOR.rgb -= step(COLOR.rgb, vec3((blink_percentage * 0.75) / UV.y));
	COLOR.rgb -= step(COLOR.rgb, vec3((blink_percentage) / UV.y));
}