class Water {

  float x, y, h, spd, targetHeight;

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

  void display(color c, boolean customOpacity) {
    if (customOpacity) {
      fill(c, 255 - h / 3);
    } else {
      fill(c, 60);
    }
    vertex(x, h);
  }
}
