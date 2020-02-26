
// Consts --------------------
static PVector Zero = vector(0);
static PVector One = vector(1);
static PVector HalfColor = vector(127);
static PVector FullColor = vector(255);

// Constructors --------------
static PVector vector(float x) { return new PVector(x,x,x); }

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
	return color(v.x,v.y,v.z,255);
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