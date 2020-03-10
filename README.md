# Webcam Flow

An interactive program that visualizes optical flow. Created using Processing 3.

## Running

Run the sketch's main file, `WebcamFlow.pde`, with processing-java.

## Controls

There are several keyboard bindings to change some parameters at run time:
- `LEFT ARROW` - decrease flow linger
- `RIGHT ARROW` - increase flow linger
- `DOWN ARROW` - reset flow linger to 0.5
- `D` - toggle debug view
- `R` - reset flow map and display
- `F` - flip horizontal
- `M` - cycle display mode
- `B` - toggle bilinear interpolation (can only be disabled for display modes not using GLSL)

## Troubleshooting

If only a black screen is shown on startup, it may help to refresh the canvas by pushing `D` twice to toggle the debug view on then off.