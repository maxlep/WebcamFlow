
import gab.opencv.*;
import processing.video.*;

// Params --------------------
int camWidth =  320;		// we'll use a smaller camera resolution, since
int camHeight = 180;		// HD video might bog down our computer
PVector cameraSize = new PVector(camWidth,camHeight);
PVector windowSize = new PVector(width,height);

int gridTileSize = 10;		// The camera image is further divided into regions to measure flow
							// and we get the average movement in each
boolean doGridBilinearInterpolation = true;	// Whether to smooth the grid by sampling using bilinear interpolation

int mode = 0;				// Different modes for visualizing the flowmap
static int modeCount = 5;

boolean debug = false;		// Debug mode

// Main   --------------------
OpenCV cv;
Capture webcam;

String cameraName;

void setup()
{
	size(1280, 720);
	windowSize = new PVector(width,height);

	// Start the webcam
	String[] inputs = Capture.list();
	printArray(inputs);
	if (inputs.length == 0) {
		println("Couldn't detect any webcams connected!");
		exit();
	}
	cameraName = inputs[0];
	webcam = new Capture(this, camWidth,camHeight, cameraName);
	webcam.start();

	cv = new OpenCV(this, camWidth,camHeight);		// Create an instance of the OpenCV library
	initializeFlowMap();							// Initialize the PImage used to store the flow map
}

static int ui_x = 4, ui_y = 12, fontSize = 12;
void draw()
{
	if (webcam.available())
	{
		webcam.read();
		cv.loadImage(webcam);
		cv.calculateOpticalFlow();		// Initialize OpenCV and calculate optical flow
		updateFlowMap(0.8);				// Sample the optical flow on a grid and store to flowmap image

		displayFlow(webcam);

		if (debug)
		{
			int quarterWidth  =  width/4;
			int quarterHeight = height/4;
			fill(color(0,255,0));
			textSize(fontSize);
			image(flowmap,0,0,quarterWidth,quarterHeight);
			text("Flow map", ui_x,ui_y);
			text(String.format("res: %dx%d", gridWidth,gridHeight), ui_x,ui_y+fontSize);
			text(String.format("linger: %.2f", flowLinger), ui_x,ui_y+2*fontSize);
			image(webcam,0,quarterHeight,quarterWidth,quarterHeight);
			text(cameraName, ui_x,ui_y+quarterHeight);
			text(String.format("display mode: %d", mode), ui_x+quarterWidth,ui_y);
		}
	}
}

void keyPressed()
{
	if (key == 'd')
	{
		debug = !debug;
	} else if (key == 'm') 
	{
		mode = (mode + 1) % modeCount;
	} else if (key == 'r')
	{
		initializeFlowMap();
		background(vectorToColor(HalfColor));
	} else if (key == 'f')
	{
		flipHorizontal = !flipHorizontal;
	} else if (key == 'b')
	{
		doGridBilinearInterpolation = !doGridBilinearInterpolation;
	}
}