import java.util.*;

final int BLOCK_SIZE = 100;

boolean movement[] = {false, false, false, false};
void setup() {
  fullScreen();
}
void draw() {
  background(0);
  renderMap();
}
void renderMap() {
  noStroke();
  for (int i=0; i<tilemap.length; i++) {
    for (int j=0; j<tilemap[i].length; j++) {
      if (tilemap[i][j] == 1) {
        fill(255, 0, 255);
        rect(j * BLOCK_SIZE, i * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
      }
    }
  }
  int mouseXIndex = int(mouseX / BLOCK_SIZE);
  int mouseYIndex = int(mouseY / BLOCK_SIZE);
  IntPair start = new IntPair(0, 0);
  IntPair stop = new IntPair(mouseXIndex, mouseYIndex);
  Node path = Astar(start, stop);

  Node current = path;
  while (current != null) {
    IntPair currentLocation = current.location;
    current = current.parent;
    if (current != null) {
      strokeWeight(20);
      stroke(255, 255, 0);
      line(currentLocation.first * BLOCK_SIZE + BLOCK_SIZE / 2, currentLocation.second * BLOCK_SIZE + BLOCK_SIZE / 2,
      current.location.first * BLOCK_SIZE + BLOCK_SIZE / 2, current.location.second * BLOCK_SIZE + BLOCK_SIZE / 2);
    } else {
      noStroke();
      fill(255, 255, 0);
      ellipse(currentLocation.first * BLOCK_SIZE + BLOCK_SIZE / 2, currentLocation.second * BLOCK_SIZE + BLOCK_SIZE / 2, BLOCK_SIZE / 2, BLOCK_SIZE / 2);
    }
  }
}
void mousePressed() {
  if (mouseButton == 39) {//right
    int mouseXIndex = int(mouseX / BLOCK_SIZE);
    int mouseYIndex = int(mouseY / BLOCK_SIZE);
    if (mouseXIndex > -1 && mouseXIndex < tilemap[0].length && mouseYIndex > -1 && mouseYIndex < tilemap.length) {
      tilemap[mouseYIndex][mouseXIndex] = 1;
    }
  }
  if (mouseButton == 37) {//left
  }
}
