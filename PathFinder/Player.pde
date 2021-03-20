class Player {
  PVector position;
  PVector real_position;
  Node path;
  boolean isFinishedMoving = true;
  Player(float x, float y) {
    position = new PVector(x, y);
    real_position = position;
  }
  void update() {
    position.x = lerp(position.x, real_position.x, 0.2);
    position.y = lerp(position.y, real_position.y, 0.2);
    //follow the path
    if (path != null) {
      Node nextNode = path.parent;
      if (nextNode != null) {
        //when the object steps onto the next block, it will update
        if (dist(nextNode.location.first * BLOCK_SIZE + BLOCK_SIZE / 2, nextNode.location.second * BLOCK_SIZE + BLOCK_SIZE / 2, position.x, position.y) < 5) {
          path = path.parent;
        }

        if(path.parent != null) {
          //move in the direction
          PVector direction = new PVector(path.parent.location.first - path.location.first, path.parent.location.second - path.location.second);
          direction.normalize();
          direction.mult(5);
          //position.add(direction);
          real_position.add(direction);
        } else {
          isFinishedMoving = true;
        }
      }
    }
  }
  void render() {
    fill(255);
    ellipse(position.x, position.y, BLOCK_SIZE, BLOCK_SIZE);
  }
  void follow(Node p) {
    //follow
    if(isFinishedMoving) {
      path = p;
      isFinishedMoving = false;
    }
  }
}
