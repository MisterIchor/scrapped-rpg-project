shader_type canvas_item;

uniform float displacement_x = 0.0;
uniform float displacement_y = 0.0;

void vertex() {
	float x1 = smoothstep(UV.x - UV.y, 0.0, 1.0) * (displacement_x * 0.5);
	float x2 = smoothstep(UV.x + UV.y, 0.0, 1.0) * displacement_x;
	float y1 = smoothstep(UV.y * 2.0, 0.0, 1.0) * abs(displacement_y);
	
	VERTEX.x += x1 + x2;
	VERTEX.y -= y1;
}


void fragment() {
	
}