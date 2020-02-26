
import gab.opencv.*;
import processing.video.*;

// Params --------------------
int camWidth =  320;		// we'll use a smaller camera resolution, since
int camHeight = 180;		// HD video might bog down our computer
PVector cameraSize = new PVector(camWidth,camHeight);
PVector windowSize = new PVector(width,height);

int gridTileSize = 5;		// The camera image is further divided into regions to measure flow
							// and we get the average movement in each

int mode = 2;				// Different modes for visualizing the flowmap
static int modeCount = 4;

boolean debug = false;		// Debug mode

// Main   --------------------
OpenCV cv;
Capture webcam;

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
	webcam = new Capture(this, camWidth,camHeight, inputs[0]);//"Integrated_Webcam_HD: Integrate");//"UVC Camera (046d:0825)");
	webcam.start();

	cv = new OpenCV(this, camWidth,camHeight);		// Create an instance of the OpenCV library
	initializeFlowMap();							// Initialize the PImage used to store the flow map
}

void draw()
{
	if (webcam.available())
	{
		webcam.read();
		image(webcam, 0,0, width,height);	// Draw the raw webcam image to the screen

		cv.loadImage(webcam);
		cv.calculateOpticalFlow();			// Initialize OpenCV and calculate optical flow
		updateFlowMap(0.8);					// Sample the flow map on a grid and store to flowmap image

		displayFlow();

		if (debug)
		{
			image(flowmap,0,0,width/4,height/4);
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
	}
}