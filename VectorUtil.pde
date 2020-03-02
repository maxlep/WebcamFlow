
// Consts --------------------
static PVector Zero = vector(0);
static PVector One = vector(1);
static PVector HalfColor = vector(127);
static PVector FullColor = vector(255);

// Constructors --------------
static PVector vector(float x) { return new PVector(x,x,x); }
static PVector vector(PVector v) { return new PVector(v.x,v.y,v.z); }

// Color  --------------------
PVector colorToVector(color c)
{
	int r = c >> 16 & 0xFF;
	int g = c >> 8 & 0xFF;
	int b = c & 0xFF;
	int a = c >> 24 & 0xFF;
	return new PVector(r,g,b);
}
color vectorToColor(PVector v)
{
	return vectorToColor(v, 255);
}
color vectorToColor(PVector v, float a)
{
	return color(v.x, v.y, v.z, a);
}
color addColor(color c1, color c2)
{
	int r = constrain( (c1 >> 16 & 0xFF) + (c2 >> 16 & 0xFF), 0,255 );
	int g = constrain( (c1 >> 8 & 0xFF) + (c2 >> 8 & 0xFF), 0,255 );
	int b = constrain( (c1 & 0xFF) + (c2 & 0xFF), 0,255 );
	return color(r,g,b);
}
color mixColor(color c1, color c2, float pct1)
{
	float pct2 = 1 - pct1;
	int r = constrain( int((c1 >> 16 & 0xFF)*pct1 + (c2 >> 16 & 0xFF)*pct2), 0,255 );
	int g = constrain( int((c1 >> 8 & 0xFF)*pct1 + (c2 >> 8 & 0xFF)*pct2), 0,255 );
	int b = constrain( int((c1 & 0xFF)*pct1 + (c2 & 0xFF)*pct2), 0,255 );
	return color(r,g,b);
}
PVector mix(PVector v1, PVector v2, float pct1)
{
	PVector result = vector(0);
	addInPlace( result, PVector.mult(v1,   pct1) );
	addInPlace( result, PVector.mult(v2, 1-pct1) );
	return result;
}

// Logic  --------------------
void constrainInPlace(PVector v, PVector min, PVector max)
{
	v.x = constrain(v.x, min.x,max.x);
	v.y = constrain(v.y, min.y,max.y);
	v.z = constrain(v.z, min.z,max.z);
}

// Math   --------------------
void addInPlace(PVector v1, PVector v2)
{
	v1.x += v2.x;
	v1.y += v2.y;
	v1.z += v2.z;
}
void subInPlace(PVector v1, PVector v2)
{
	v1.x -= v2.x;
	v1.y -= v2.y;
	v1.z -= v2.z;
}
void multInPlace(PVector v1, PVector v2)
{
	v1.x *= v2.x;
	v1.y *= v2.y;
	v1.z *= v2.z;
}
void multInPlace(PVector v, float f)
{
	v.x *= f;
	v.y *= f;
	v.z *= f;
}
void divideInPlace(PVector v1, PVector v2)
{
	v1.x /= v2.x;
	v1.y /= v2.y;
	v1.z /= v2.z;
}