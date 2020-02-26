
void coordFrameToCoordFrame(PVector coord, PVector fromFrame, PVector toFrame)
{
	divideInPlace(coord, fromFrame);
	multInPlace(coord, toFrame);
}
int coordToIndex(PVector coord, PVector frameSize)
{
	return floor(coord.y) * int(frameSize.x) + floor(coord.x);
}
int coordFrametoFrameIndex(PVector coord, PVector fromFrame, PVector toFrame)
{
	coordFrameToCoordFrame(coord, fromFrame, toFrame);
	return coordToIndex(coord, toFrame);
}

int windowCoordToGridIndex(PVector windowCoord)
{
	return coordFrametoFrameIndex(windowCoord, windowSize, gridSize);
}

int cameraCoordToGridIndex(PVector cameraCoord)
{
	return coordFrametoFrameIndex(cameraCoord, cameraSize, gridSize);
}