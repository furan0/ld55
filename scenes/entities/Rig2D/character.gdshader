shader_type canvas_item;

uniform vec3 overridecolor : source_color  = vec3(0.0,0.0,0.0);
uniform vec4 blink_color : source_color = vec4(0.0,0.0,0.0,0.0);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = texture(TEXTURE,UV).rgb;
	float red_factor = (color.r)/(color.r+color.g+color.b+0.00001);
	red_factor = clamp(red_factor,0.0,1.0); 
	red_factor = 1.0-step(red_factor,0.9);
	COLOR.rgb = mix(mix(color,color.r * overridecolor,red_factor),blink_color.rgb,blink_color.a); 
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
