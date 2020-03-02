
void displayFlow(PImage cameraFrame)
{
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
				case 0:		// Simple mix of webcam input with flow direction, based on flow intensity
					PVector motion = mix( cameraSample, flow, 0.5 );
					pixels[windowIndex] = mixColor( pixels[windowIndex], vectorToColor(motion), pct );
					break;
				case 1:		// Black clouds
					if (abs(pct) > 0.1) windowSample = PVector.mult(windowSample,pct);
					pixels[windowIndex] = vectorToColor(windowSample, 0.2);
					break;
				case 2:
					if (abs(pct) < 0.4) pixels[windowIndex] = int(pixels[windowIndex] * pct);
					break;
				case 3:
					pct = max(pct, .1);
					if (abs(pct) < 0.4) pixels[windowIndex] = int(pixels[windowIndex] * pct);
					break;
				case 4:
					break;
			}
		}
	}
	updatePixels();
}