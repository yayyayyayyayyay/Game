shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler2D NOISE_TEXTURE : repeat_enable;
uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 noise_color = texture(NOISE_TEXTURE,SCREEN_UV+(TIME/10.0)).rgb;
    vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV+(noise_color.b / 20.0)).rgb;

    // Slight desaturation
    //float gray = dot(screen.rgb, vec3(0.299, 0.587, 0.114));
    //screen.rgb = mix(screen.rgb, vec3(gray), 0.3 * strength);


    screen.rgb += vec3(0.0, 0.25, 0.0) * strength;

    COLOR.rgb = screen;
}
