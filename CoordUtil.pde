
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