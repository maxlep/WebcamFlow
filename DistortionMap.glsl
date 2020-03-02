// Author: Max Lepkowski
// Title: Flow

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
// uniform vec2 u_mouse;
// uniform float u_time;
uniform sampler2D u_camera;
uniform vec2 u_cameraResolution;
uniform sampler2D u_flowmap;
uniform vec2 u_flowmapResolution;

void main()
{
    vec2 pCoord = gl_FragCoord.xy;
    // pCoord.y = u_resolution.y - gl_FragCoord.y;
    pCoord = u_resolution - gl_FragCoord.xy;
    vec2 st = pCoord.xy / u_resolution.xy;
    vec4 color = vec4(0.);

    vec4 flowSample = (texture(u_flowmap, st) - 0.5) * 0.5;
    vec2 coord = st + flowSample.xy;
    vec4 imgSample = texture(u_camera, coord) + flowSample;

    // color = flowSample;
    color.rgba = imgSample.rgba;

    gl_FragColor = color;
}