float xspacing = 4;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
float theta = 0.0;  // Start angle at 0
float amplitude = 10.0;  // Height of wave
float period = 55.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

class Water {

  public float x, y, h, spd, targetHeight;

  Water(float _x, float _y, float _h, float th, float s) {
    targetHeight = _h;
    h = th;
    spd = s;
    x = _x;
    y = _y;
  }

  void update(float damp, float ten) {
    float x = targetHeight - h;
    spd += ten * x - spd * damp;
    h += spd;
  }

  void display(color c, boolean customOpacity, float al) {
    //if (xspacing <= 1) {
    //  al = 255 - h / 3;
    //} else {
    //  al = map(xspacing, 1, 4, 255, 50);
    //}
    
    if (customOpacity) {
      fill(c, al);
    } else {
      fill(c, al);
    }
    vertex(x, h);
  }
}

void drawPixelatedWater() {
  // Increment theta (try different values for 'angular velocity' here
  println("xspacing ", xspacing);
  if (floor(xspacing) <= 1) {
    yvalues = new float[30];
  }
  yvalues = new float[w/floor(xspacing)];
  w = width / aec.getScaleX() + 1;
  dx = (TWO_PI / period) * xspacing;
  theta += 0.08;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x) * amplitude;
    x+=dx;
  }

  renderWave();
}

void renderWave() {
  noStroke();
  fill(color(63, 135, 252), map(xspacing, 1, 4, 0, 255));
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    rect(x * xspacing, (height / aec.getScaleY() / 4) + yvalues[x], 2, (height / aec.getScaleY()));
  }
}
