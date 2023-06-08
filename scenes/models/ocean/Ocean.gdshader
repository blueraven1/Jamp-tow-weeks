shader_type spatial;

uniform sampler2D noise;
uniform sampler2D normalmap;

uniform float height_scale = 0.5;
varying vec2 tex_position;

float height(vec2 position, float time) {
  vec2 offset = 0.01 * cos(position + time);
  return texture(noise, (position / 10.0) - offset).x;
}

void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 1.0 * (1.0 - fresnel);
	ALBEDO = vec3(0.01, 0.03, 0.05);
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
}

void vertex() {
	vec2 pos = VERTEX.xz;
	float k = height(pos, TIME);
	VERTEX.y += k;
	
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
}

render_mode specular_toon;