
void displayFlow(PImage cameraFrame)
{
    // webcam.loadPixels();
    cameraFrame.loadPixels();
    flowmap.loadPixels();
    loadPixels();
    for (int x=0; x<width; x++)
    {
        for (int y=0; y<height; y++)
        {
            PVector windowCoord = new PVector(x,y);
            int windowIndex = coordToIndex(windowCoord, windowSize);
            int cameraIndex = windowCoordToCameraIndex(windowCoord);
            int gridIndex = windowCoordToGridIndex(windowCoord);

            // gridIndex = floor(constrain(gridIndex, 0,gridSize.x*gridSize.y-1));
            PVector flow = colorToVector(flowmap.pixels[gridIndex]);
            float pct = map(flow.y, 0,255, -1,1);
            PVector sample = colorToVector(pixels[windowIndex]);
            sample = PVector.add(sample, new PVector(127,127,127));
            switch (mode)
            {
                case 0:
                    if (abs(pct) < 0.3) {
                        sample.y = sample.x; sample.z = sample.x;
                        // sample = PVector.mult(sample,pct);
                    }
                    else sample = PVector.mult(sample,abs(pct)+1);
                    sample = PVector.sub(sample, new PVector(127,127,127));
                    pixels[windowIndex] += vectorToColor(sample, 0.2);
                    break;
                case 1:
                    if (abs(pct) > 0.1) sample = PVector.mult(sample,pct);
                    pixels[windowIndex] = vectorToColor(sample, 0.2);
                    break;
                case 2:
                    if (abs(pct) < 0.4) pixels[windowIndex] = int(pixels[windowIndex] * pct);
                    break;
                case 3:
                    pct = max(pct, .1);
                    if (abs(pct) < 0.4) pixels[windowIndex] = int(pixels[windowIndex] * pct);
                    break;
                case 4:
                    // if (abs(pct) > 0.1) pixels[windowIndex] = addColor( cameraFrame.pixels[cameraIndex], vectorToColor(flow, 0) );
                    PVector cameraSample = colorToVector(cameraFrame.pixels[cameraIndex]);
                    PVector motion = mix( cameraSample, flow, 0.5 );
                    pixels[windowIndex] = mixColor( pixels[windowIndex], vectorToColor(motion, 0.5), pct );
                    break;
            }
        }
    }
    updatePixels();
}