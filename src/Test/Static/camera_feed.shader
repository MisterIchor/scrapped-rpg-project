shader_type canvas_item;

uniform vec2 shake_intensity = vec2(0.0);
uniform float static_intensity = 0.0;
uniform float flicker_intensity = 0.0;
uniform float glitch_intensity = 0.0;
uniform float zoom_scale = 1.0;
const float pi = 3.14159265359;



float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void vertex() {
	if (shake_intensity.x > 0.0) {
		UV.x += mod(TIME, TEXTURE_PIXEL_SIZE.x * (0.5 + (7.0 * shake_intensity.x)));
	}
	UV.y += mod(TIME, TEXTURE_PIXEL_SIZE.y * (0.5 + (7.0 * shake_intensity.y)));
//	UV *= 2.0;
//	UV.y -= tan(TIME * 0.25);
//	UV.x += sin(TIME * UV.y) * 2.0;
//	UV.y += sin(TIME * UV.x) * 2.0;
//	UV.x += sin((TIME * glitch_intensity) * UV.x);
//	UV.y += TIME;
//	UV.y += sin(TIME * UV.y);
//	UV.y += 16.0;
}


void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if (static_intensity > 0.0) {
		if (static_intensity < 1.0) {
			if (rand(vec2(TIME * SCREEN_UV.y)) > 1.0 - (0.3 * static_intensity)) {
				COLOR.rgb += 0.3 * static_intensity;
			}
		}
		
		COLOR.rgb = mix(vec3(rand(UV)) / 1.5, COLOR.rgb, vec3(1.0 - static_intensity));
	}
	
//	COLOR = mix(texture(noise, UV), COLOR, vec4(0.5));
	
	if (rand(vec2(TIME, 0.0)) > (0.98 - (0.6 * flicker_intensity))) {
		COLOR.rgb += 0.005 + (0.05 * flicker_intensity);
	}
	
	COLOR.rgb *= mix(vec3(1.0), COLOR.rgb, sin(1024.0 * (SCREEN_UV.y)));
//	COLOR.rgb -= 0.2;
	COLOR.rgb = mix(vec3(0.0), COLOR.rgb, vec3(clamp(sin((UV.y - (mod(TIME / 2.0, 9.0 )))), 0.9, 1.0)));
//	COLOR.rgb *= mix(vec3(1.0), COLOR.rgb, vec3(sin(UV.y + mod(TIME, 2048.0))));
}