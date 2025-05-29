shader_type canvas_item;

uniform bool is_flashing = true;



void vertex() {
	if ( is_flashing ) {
		COLOR.rgb -= 0.2 * abs(sin(TIME * 8.0));
	}
//	COLOR.rgb = vec3(abs(0.5 * tan(TIME * 8.0)));
}