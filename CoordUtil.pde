
boolean flipHorizontal = true;

void coordFrameToCoordFrame(PVector coord, PVector fromFrame, PVector toFrame)
{
	coordFrameToCoordFrame(coord, fromFrame, toFrame, true);
}

PVector coordFrameToCoordFrame(PVector coord, PVector fromFrame, PVector toFrame, boolean inPlace)
{
	PVector outCoord = inPlace ? coord : vector(coord);
	divideInPlace(outCoord, fromFrame);
	multInPlace(outCoord, toFrame);
	return outCoord;
}

int coordToIndex(PVector coord, PVector frameSize)
{
	return floor(coord.y) * int(frameSize.x) + floor(coord.x);
}

PVector indexToCoord(int index, PVector frame)
{
	PVector result = vector(0);
	result.y = index / frame.x;
	result.x = index % frame.x;
	return result;
}

int coordFrametoFrameIndex(PVector coord, PVector fromFrame, PVector toFrame)
{
	PVector toCoord = coordFrameToCoordFrame(coord, fromFrame, toFrame, false);
	return coordToIndex(toCoord, toFrame);
}

int windowCoordToGridIndex(PVector windowCoord)
{
	return coordFrametoFrameIndex(windowCoord, windowSize, gridSize);
}

int windowCoordToCameraIndex(PVector windowCoord)
{
	return coordFrametoFrameIndex(windowCoord, windowSize, cameraSize);
}

int cameraCoordToGridIndex(PVector cameraCoord)
{
	return coordFrametoFrameIndex(cameraCoord, cameraSize, gridSize);
}

void flipHorizontal(PVector coord, PVector frame)
{
	coord.x = frame.x - 1 - coord.x;
}

PVector bilinearInterpolation(PVector floatCoord, PVector frame, color[] toPixels)
{
	int fw = int(frame.x), fh = int(frame.y);
	int xLo = floor(floatCoord.x), xHi = ceil(floatCoord.x);
	int yLo = floor(floatCoord.y), yHi = ceil(floatCoord.y);
	int loIndex = yLo * fw + xLo;
	color c1 = toPixels[loIndex];
	color c2 = toPixels[constrain(loIndex+1, 0,toPixels.length-1)];
	color c3 = toPixels[constrain(loIndex+fw, 0,toPixels.length-1)];
	color c4 = toPixels[constrain(loIndex+fw+1, 0,toPixels.length-1)];
	float a = floatCoord.x - xLo, b = floatCoord.y - yLo;
	
	PVector result = vector(0);
	addInPlace( result, PVector.mult(colorToVector(c1), (1-a)*(1-b)) );
	addInPlace( result, PVector.mult(colorToVector(c2), a*(1-b)) );
	addInPlace( result, PVector.mult(colorToVector(c3), (1-a)*b) );
	addInPlace( result, PVector.mult(colorToVector(c4), a*b) );
	return result;
}