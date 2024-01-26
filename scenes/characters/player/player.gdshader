shader_type canvas_item;


uniform vec2 fireScroll = vec2(0.0, 1.0);
uniform float fireScrollSpeed : hint_range(0, 3, 0.01) = 0.1;
uniform sampler2D fireNoise : repeat_enable;

uniform int element : hint_range(0, 4, 1) = 1;
uniform int amount = 400;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 elementColor;
	vec4 noiseColor;
	vec2 grid_uv = round(SCREEN_UV * float(amount)) / float(amount);
	
	switch (element) {
		case 0:
			break;
		case 1:
			noiseColor = texture(fireNoise, grid_uv + (fireScroll * fireScrollSpeed * TIME));
			break;
		case 2:
			break;
		case 3:
			break;
		case 4:
			break;
	}
	if (pixelColor == vec4(1.0)) {
		pixelColor = noiseColor;
	}
	COLOR = pixelColor;
}

