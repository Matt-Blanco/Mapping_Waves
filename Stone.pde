class Stone {

  PVector pos;
  PVector vel;
  PVector acc;
  float alpha;

  Stone(PVector p) {
    pos = p;
    acc = new PVector(0, 0.05);
    vel = new PVector(0, 2);
    alpha = 0;
  }

  void run() {
    vel.add(acc);
    pos.add(vel);
    display();
  }

  void display() {
    fill(255, alpha);
    ellipse(pos.x, pos.y, 1, 1);
  }
}
