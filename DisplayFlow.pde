

static int CameraUpdateResetValue = -30000;
int lastCameraUpdateTime = CameraUpdateResetValue;
PImage cameraBuffer;

void displayFlow(PImage cameraFrame)
{
	if (mode == 0) {
		flowmap.filter(BLUR);
		distortionMapShader.set("u_flowmap", flowmap);
		int time = millis();
		println(averageFlow);
		if (time - lastCameraUpdateTime >= cameraDelayMs || averageFlow.mag() > 1.5)
		{
			lastCameraUpdateTime = time;
			cameraBuffer = cameraFrame.copy();
			distortionMapShader.set("u_camera", cameraBuffer);
		}
		filter(distortionMapShader);
		return;
	}
	cameraFrame.loadPixels();
	flowmap.loadPixels();
	loadPixels();
	for (int x=0; x<width; x++)
	{
		for (int y=0; y<height; y++)
		{
			// Calculate this pixels indices in the varying coordinate frames
			PVector windowCoord = new PVector(x,y);
			int windowIndex = coordToIndex(windowCoord, windowSize);
			if (flipHorizontal) flipHorizontal(windowCoord, windowSize);
			int cameraIndex = windowCoordToCameraIndex(windowCoord);
			int gridIndex = windowCoordToGridIndex(windowCoord);

			// Take samples from the different frames
			PVector flow;
			if (doGridBilinearInterpolation) {
				PVector gridCoord = coordFrameToCoordFrame(windowCoord, windowSize, gridSize, false);
				flow = bilinearInterpolation(gridCoord, gridSize, flowmap.pixels);
			} else {
				flow = colorToVector(flowmap.pixels[gridIndex]);
			}
			float pct = map(flow.y, 0,255, -1,1);
			PVector cameraSample = colorToVector(cameraFrame.pixels[cameraIndex]);
			cameraSample = PVector.add(cameraSample, new PVector(127,127,127));
			PVector windowSample = colorToVector(pixels[windowIndex]);
			windowSample = PVector.add(windowSample, new PVector(127,127,127));

			// Display results according to the mixing mode
			switch (mode)
			{
				case 0:	// Shader above
					break;
				case 1:		// Black clouds
					if (abs(pct) > 0.1) windowSample = PVector.mult(windowSample,pct);
					pixels[windowIndex] = vectorToColor(windowSample, 0.2);
					break;
				case 2:
					if (abs(pct) < 0.4) pixels[windowIndex] = int(pixels[windowIndex] * pct);
					if (abs(pct) < 0.3)
					{
						windowSample.y = windowSample.x; windowSample.z = windowSample.x;
					}
					else multInPlace(windowSample, abs(pct)+1);
					subInPlace(windowSample, HalfColor);
					pixels[windowIndex] = vectorToColor(windowSample);
					break;
				case 3:		// Simple mix of webcam input with flow direction, based on flow intensity
					PVector motion = mix( cameraSample, flow, 0.5 );
					pixels[windowIndex] = mixColor( pixels[windowIndex], vectorToColor(motion), pct );
					break;
			}
		}
	}
	updatePixels();
}