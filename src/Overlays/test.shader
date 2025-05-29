shader_type canvas_item;

uniform float gray = 1.0;



void vertex() {
	POINT_SIZE = (TEXTURE_PIXEL_SIZE.x + TEXTURE_PIXEL_SIZE.y) / 2.0;
}



void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = mix(vec3(2.0), COLOR.rgb, gray);
	COLOR.rgb = mix(vec3(0.5), COLOR.rgb, gray);
	}