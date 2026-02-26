shader_type canvas_item;
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	
	
	
	// Get the color from the screen behind the CanvasLayer
    vec4 tex_color = texture(screen_texture, SCREEN_UV);
    
    // Calculate grayscale
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray_color = vec3(gray);
    
    // Linearly interpolate between original and gray based on 'strength'
    COLOR.rgb = mix(tex_color.rgb, gray_color, strength);
    COLOR.a = tex_color.a;
}