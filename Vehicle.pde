abstract class Vehicle {
  
  PVector position, acceleration, velocity, forward, right, desired, target, steeringForce, correctiveForce;
  float radius, maxSpeed, maxForce, range, minDist, mass = 1;
  PShape body;
  
  Vehicle(float x, float y, float r, float ms, float mf) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    desired = position.copy();
    steeringForce = new PVector(0,0);
    correctiveForce = new PVector(0,0);
    target = position.copy();
    radius = r;
    maxSpeed = ms;
    maxForce = mf;
    forward = new PVector(0, 0);
    right = new PVector(0, 0);
  }
  
  abstract void calcSteeringForces();
  Vehicle display(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    shape(body,0,0);
    popMatrix();
    return this;
  }
  
  Vehicle update() {
    forward = velocity.copy().normalize();
    right.x = -forward.y;
    right.y = forward.x;
    correctiveForce.mult(0);
    if(position.x < buffer)
      correctiveForce.x = 1;
    if(position.x > width - buffer)
      correctiveForce.x = -1;
    if(position.y < buffer)
      correctiveForce.y = 1;
    if(position.y > height - buffer)
      correctiveForce.y = -1;
    calcSteeringForces();
    velocity.add(acceleration).limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
    return this;
  }

  void findClosest(ArrayList subjects){
    float tempDist;
    minDist = width;
    for(Vehicle v : (ArrayList<Vehicle>)subjects){
      if((tempDist = dist(v.position.x, v.position.y, position.x, position.y)) < minDist){
        target = v.position.copy().add(PVector.mult(v.velocity, 7));
        if(showDebug)ellipse(target.x, target.y, 5,5);
        minDist = tempDist;
      }
    }
  }

  Vehicle applyForce(PVector force) {
    acceleration.add(PVector.div(force, mass));
    return this;
  }
  
  PVector seek(PVector target) {
    desired = PVector.sub(target, position).normalize().mult(maxSpeed);
    return PVector.sub(desired, velocity);
  }
}