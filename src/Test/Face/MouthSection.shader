// Not the greatest code, but it works =P
shader_type canvas_item;

uniform vec2 texture_size;
uniform float left = 0.0;
uniform float right = 0.0;



void vertex() {
	if (right != 0.0) {
		float adjustment = ((left / right) * 0.4) + 0.6;
		
		if (sign(right) == 1.0) {
			VERTEX.y -= smoothstep(UV.y + (UV.x * adjustment), 0.0, 1.0) * right;
		} else {
			VERTEX.y -= smoothstep(UV.y - UV.x, 0.0, 1.0) * (right * 0.3);
		}
	}
	
	if (left != 0.0) {
		if (sign(left) == 1.0) {
			VERTEX.y -= smoothstep(0.0, UV.y + UV.x, 1.0) * left;
			VERTEX.y += left;
		} else {
			VERTEX.y -= smoothstep(0.0, UV.y - UV.x, 1.0) * (left * 0.5);
		}
		VERTEX.y /= ((abs(left) / texture_size.y) * 0.5) + 1.0;
	}
}



//void fragment() {
//	vec4 sides[4];
//	sides[0] = texture(TEXTURE, UV);
//
//	for (int i = 1; i < 4; i++) {
//		sides[i] = sides[0];
//	}
//
//	sides[0].a *= step(UV.x, 0.5) * step(UV.y, 0.5);
//	sides[1].a *= step(UV.x, 0.5) * step(0.5, UV.y);
//	sides[2].a *= step(0.5, UV.x) * step(UV.y, 0.5);
//	sides[3].a *= step(0.5, UV.x) * step(0.5, UV.y);
//
//	COLOR = sides[0];
//	COLOR += sides[1];
//	COLOR += sides[2];
//	COLOR += sides[3];
//}