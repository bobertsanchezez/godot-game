shader_type canvas_item;


uniform vec2 fireScroll = vec2(0.0, 1.0);
uniform float fireScrollSpeed : hint_range(0, 3, 0.01) = 0.1;
uniform sampler2D fireNoise : repeat_enable;

uniform vec4 waterColor : source_color;
uniform vec2 waterScroll = vec2(0.0, 1.0);
uniform vec2 waterScroll2 = vec2(0.0, 1.0);
uniform float waterScrollSpeed : hint_range(0, 3, 0.01) = 0.1;
uniform sampler2D waterNoise : repeat_enable;
uniform sampler2D waterNoise2 : repeat_enable;
uniform float distortionStrength : hint_range(-1.0, 1.0) = 0.2;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform int element : hint_range(0, 4, 1) = 1;
uniform int firePixels = 400;
uniform int waterPixels = 40;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 finalColor;
	
	switch (element) {
		case 0:
			break;
		case 1:
			vec2 grid_uv = round(SCREEN_UV * float(firePixels)) / float(firePixels);
			finalColor = texture(fireNoise, grid_uv + (fireScroll * fireScrollSpeed * TIME));
			break;
		case 2:
			vec4 noiseColor = texture(waterNoise, SCREEN_UV + (waterScroll * waterScrollSpeed * TIME));
			vec4 noiseColor2 = texture(waterNoise2, SCREEN_UV + (waterScroll2 * waterScrollSpeed * TIME));
			vec2 distortionUV = distortionStrength * (noiseColor.rr - noiseColor2.rr);
			distortionUV = round(distortionUV * float(waterPixels)) / float(waterPixels);
			finalColor = texture(SCREEN_TEXTURE, SCREEN_UV + distortionUV) * waterColor;
			break;
		case 3:
			break;
		case 4:
			break;
	}
	if (pixelColor == vec4(1.0)) {
		pixelColor = finalColor;
	}
	COLOR = pixelColor;
}

