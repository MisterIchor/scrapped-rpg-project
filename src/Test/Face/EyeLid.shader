shader_type canvas_item;

uniform float blink_percentage = 0.0;
uniform float mid = 0.5;



//void vertex() {
//	UV.y *= blink_percentage;
//	VERTEX.y *= blink_percentage;
//
//}


void fragment() {
	vec4 sides[2];
	float percentage = 1.0 - blink_percentage;
	
	sides[0] = texture(TEXTURE, UV);
	sides[1] = sides[0];
	sides[0].a *= step(UV.y, mid - (0.5 * percentage));
	sides[1].a *= step(mid + (0.5 * percentage), UV.y);
	COLOR = sides[0];
	COLOR.a += sides[1].a;
}