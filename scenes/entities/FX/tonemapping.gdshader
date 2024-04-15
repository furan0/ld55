shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment(){
	vec4 tone = texture(SCREEN_TEXTURE, UV);
	
	vec2 ecart = UV - vec2(0.5,0.5);
	float vignette = abs(ecart.x)+abs(ecart.y);
	
	tone = mix(tone,tone*00.0,vignette);
	COLOR.rgb = vec3(vignette,vignette,vignette);
	COLOR.a = 1.0;
}