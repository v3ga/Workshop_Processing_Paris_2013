
#define PI 3.14159265358979323846264

uniform vec2 resolution;
uniform float t;

vec2 center;
float phase;
float freq = 16.0;

void main()
{
	center = 0.5*resolution.xy;
	phase = freq*PI*distance( center, gl_FragCoord.xy ) / (0.5*resolution.x);
	float g = 0.5* (1.0 + cos(phase + t));
//	float r = 0.5* (1.0 + cos(2.0*phase + t));
	gl_FragColor = vec4(g,g,g,1);
}