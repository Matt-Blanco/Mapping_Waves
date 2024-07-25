AEC aec;
int numCols = 1200 / 16 + 1;
Water[] curWave = new Water[numCols];
Water[] curWave2 = new Water[numCols];
Water[] prevWave = new Water[numCols];
float ten=0.025; //Tension
float damp=0.001; //Dampening (Oscillating)
float spread=0.001;
Stone curStone;
Stone prevStone;
JSONObject waveData;
color bl = color(63, 135, 252);
color bl2 = color(137, 215, 255);
color wh = color(255);
float currWaveHeight;
float maxWaveHeight;

void setup() {
  size(1200, 500);

  frameRate(18);

  numCols = width / 16 + 1;

  try {
    waveData = loadJSONObject("https://marine-api.open-meteo.com/v1/marine?latitude=39.611944&longitude=-9.085556&current=wave_height&hourly=wave_height&daily=wave_height_max&timezone=GMT&past_days=7&past_hours=24&forecast_hours=24&models=best_match");
    currWaveHeight = waveData.getJSONObject("current").getFloat("wave_height");
    maxWaveHeight = getMaxFromJsonArray(waveData.getJSONObject("daily").getJSONArray("wave_height_max"));
  }
  catch (NullPointerException e) {
    print("\n", "Unable to fetch wave data using default data.", "\n");
    currWaveHeight = 0.88;
    maxWaveHeight = 3;
  }

  print(currWaveHeight, maxWaveHeight);

  for (int i=0; i < numCols; i++) {

    float cwh = map(currWaveHeight, 0, maxWaveHeight, 20, 15);
    float pwh = map(maxWaveHeight, 0, maxWaveHeight, 20 , 15);

    curWave[i] = new Water(i, 0, cwh, cwh, 0);
    curWave2[i] = new Water(i, 0, cwh + 3, cwh + 3, 0);
    prevWave[i] = new Water(i, 0, pwh, pwh, 0);
  }

  curStone = new Stone(new PVector(75, -1));
  prevStone = new Stone(new PVector(75, -1));

  aec = new AEC();
  aec.init();
}

void draw() {
  aec.beginDraw();

  fill(0);
  noStroke();
  rect(0, 0, 800, 480);

  curStone.run();
  prevStone.run();

  handleStone(prevStone, maxWaveHeight);
  handleStone(curStone, currWaveHeight);

  if (prevStone.pos.y >= 240) {
    prevStone.pos.y = -10;
    prevStone.pos.x = width / aec.getScaleX();
    prevStone.vel.y = 0.5;
    //prevStone.alpha = 255;
  }

  if (curStone.pos.y >= 240) {
    curStone.pos.y = -10;
    curStone.pos.x = width / aec.getScaleX();
    curStone.vel.y = 2;
    //curStone.alpha = 255;
  }

  drawWave(prevWave, wh, prevStone, false);
  drawWave(curWave, bl, curStone, true);
  drawWave(curWave2, bl2, curStone, true);

  aec.endDraw();
  aec.drawSides();
}

void drawWave(Water[] water, color c, Stone stone, boolean customOpacity) {
  beginShape();
  for (int i = 0; i < numCols; i++) {
    water[i].display(c, customOpacity);
    water[i].update(damp, ten);

    if (stone.pos.y <= 40 && stone.vel.y >= 1.8) {
      water[int(stone.pos.x)].h = stone.vel.y * stone.vel.y * 4;
      stone.alpha=0;
    }

    float[] lDeltas = new float[numCols];
    float[] rDeltas = new float[numCols];

    for (int j = 0; j < 8; j++) {

      for (int l = 0; l < numCols; l++) {
        if (l > 0) {
          lDeltas[l]= spread * (water[l].h - water[l-1].h);
          water[l-1].spd += lDeltas[l];
        }

        if (l < numCols-1) {

          rDeltas[l] = spread * ( water[l].h -  water[l+1].h);
          water[l+1].spd += rDeltas[l];
        }
      }

      for (int r = 0; r < numCols; r++)
      {
        if (r > 0)
          water[r - 1].h += lDeltas[r];
        if (r < numCols - 1)
          water[r + 1].h += rDeltas[r];
      }
    }
  }
  vertex(width, 80);
  vertex(-5, 80);
  endShape(CLOSE);
}

void keyPressed() {
  aec.keyPressed(key);
}

float getMaxFromJsonArray(JSONArray arr) {
  float max = 0;
  for (int i = 0; i < arr.size(); i++) {
    float v = arr.getFloat(i);

    if (v >= max) {
      max = v;
    }
  }
  return max;
}

void handleStone(Stone s, float h) {
  if (s.pos.y >= 240) {
    s.pos.y = -10;
    s.pos.x = width / aec.getScaleX();
    s.vel.y = map(h, 0, maxWaveHeight, 1, 2.1);
    //prevStone.alpha = 255;
  }
}
