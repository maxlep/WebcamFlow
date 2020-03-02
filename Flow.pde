
int gridWidth = camWidth/gridTileSize;
int gridHeight = camHeight/gridTileSize;
PVector gridSize = new PVector(gridWidth,gridHeight);

PImage flowmap;
float flowLinger = .9;

void initializeFlowMap()
{
	flowmap = new PImage(gridWidth,gridHeight);
	flowmap.loadPixels();
	for (int i=0; i<flowmap.pixels.length; i++)
	{
		flowmap.pixels[i] = vectorToColor(HalfColor);
	}
	flowmap.updatePixels();
}

void updateFlowMap(float fillPercent)
{
	int randMax = gridTileSize * int((1/fillPercent)-1);
	flowmap.loadPixels();
	for (int y=gridTileSize; y<camHeight-gridTileSize; y+=gridTileSize)
	{
		for (int x=gridTileSize; x<camWidth-gridTileSize; x+=gridTileSize)
		{
			PVector flow = cv.flow.getAverageFlowInRegion(x,y, gridTileSize,gridTileSize);
			flow = PVector.mult( flow, 16 );							// Get the average flow in this grid square
			PVector cameraCoord = new PVector(x,y);
			int gridIndex = cameraCoordToGridIndex(cameraCoord);		// Translate camera coordinates to grid index
			PVector currentFlow = colorToVector(flowmap.pixels[gridIndex]); // Sample flowmap
			flowAttenuation(currentFlow, flow, flowLinger);				// Calculate resultant flow
			flowmap.pixels[gridIndex] = vectorToColor(currentFlow);		// Update flowmap value
			x += int(random(0,randMax));								// Add random to grid increment to reduce updates
		}
	}
	flowmap.updatePixels();
}

void flowAttenuation(PVector currentFlow, PVector momentFlow, float lingerFactor)
{
	subInPlace(currentFlow, HalfColor);		// Normalize currentFlow from the range 0-255 to the range -127-127
	multInPlace( currentFlow, lingerFactor );								// Persist the flowmap by linger factor
	addInPlace( currentFlow, PVector.mult(momentFlow,1-lingerFactor) );		// Factor in the momentary flow
	// result = PVector.add( PVector.mult(result,lingerFactor), PVector.mult(momentFlow,1-lingerFactor) );
	// currentFlow = PVector.add( PVector.mult(currentFlow,(1-flowLinger)*mag), PVector.mult(flow,flowLinger*(1-mag)) );
	addInPlace(currentFlow, HalfColor);
	constrainInPlace(currentFlow, Zero,FullColor);
}