shader_type canvas_item;


uniform vec4 fireColor : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec2 fireScroll = vec2(0.0, 0.0);
uniform sampler2D fireNoise;

uniform float fireBrightness : hint_range(0.0, 1.0) = 1.0;

uniform int element : hint_range(0, 4, 1) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 elementColor;
	vec4 noiseColor;
	switch (element) {
		case 0:
			break;
		case 1:
			elementColor = fireColor;
			noiseColor = texture(fireNoise, SCREEN_UV);
			break;
		case 2:
			break;
		case 3:
			break;
		case 4:
			break;
	}
	if (pixelColor == vec4(1.0)) {
		pixelColor = elementColor;
		if (noiseColor != vec4(0.0)) {
			//pixelColor = elementColor + noiseColor * 0.5;
			pixelColor = noiseColor * fireBrightness;
		}
	}
	COLOR = pixelColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
