PImage img1;
PImage img2;
PImage img3;
int numBalls = 1000;
float spring = 0.05;
float gravity = 0.5;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];
int BallCount = 0; //ball count

void setup() {
  size(1140, 660, P3D);
  
  //for (int i = 0; i < numBalls; i++) {
  //  balls[i] = new Ball(random(width), random(height), 0,  70, i, balls);
  //}
  background(0);
  img1 = loadImage("images/");
  img2 = loadImage("images/");
  img3 = loadImage("images/");
  stroke(255);
  noFill();
}


void draw(){
    background(0);  //0, 1, 0);
    camera(mouseX, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
 
beginShape(); //front (far) wall begin 
texture(img1);
vertex(0, 0, -400,0,0);
vertex(0, 660, -400,0,img1.height);
vertex( 1140,  660, -400,img1.width,img1.height);
vertex( 1140, 0, -400,img1.width,0);
endShape(CLOSE);  //front (far) wall end

beginShape(); //floor begin
texture(img2);
  vertex(0, 660,-400, 0, 0);
  vertex(0, 660, 0, 0, img2.height);
  vertex(1140, 660, 0, img2.width,img2.height);
  vertex(1140, 660, -400, img2.width,0);
endShape(CLOSE); //floor end

beginShape(); //left wall begin
texture(img3);
  vertex(0,  660, 0, 0, img3.height);
  vertex(0, 0, 0, 0, 0);
  vertex(0, 0,-400, img3.width, 0);
  vertex(0, 660, -400, img2.width,img2.height);
endShape(CLOSE); //left wall end

beginShape(); //right wall begin
texture(img3);
  vertex(1140, 660, 0, 0, img3.height);
  vertex(1140, 0, 0, 0, 0);
  vertex(1140, 0,-400, img3.width, 0);
  vertex(1140, 660, -400, img2.width,img2.height);
endShape(CLOSE); //right wall end

beginShape(); //ceiling begin
texture(img2);
  vertex(0, 0, 0, 0, 0);
  vertex(1140, 0, 0, img2.width,0);
  vertex(1140, 0,-400, img2.width, img2.height);
  vertex(0, 0, -400, 0, img2.height);
endShape(CLOSE); //ceiling end
 
if(balls[0]!=null){
 for (int i=0;i<BallCount;i++) {
    //pushMatrix();
    balls[i].collide();
    balls[i].move();
    balls[i].display();
    //popMatrix();
  }
} 
}

void mousePressed() {
  balls[BallCount] = new Ball(mouseX, mouseY, 0,  70, BallCount, balls);
  ++BallCount;
}

class Ball {
  PShape sphere;
  PImage sphereTexture;
  float x, y, z;
  float diameter;
  float vx = 0;
  float vy = 0;
  float vz = 9;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float zin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    z = zin;
    diameter = din;
    sphere = createShape(SPHERE,diameter/2);
    sphereTexture = loadImage(sketchPath("") + "textures/"+nf(int(random(1, 10))) + ".jpg");
    sphere.setTexture(sphereTexture);
    sphere.setStroke(false);
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < BallCount; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float dz = others[i].z - z;
      float distance = sqrt(dx*dx + dy*dy + dz*dz);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float targetZ = z + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        float az = (targetZ - others[i].z) * spring;
        vx -= ax;
        vy -= ay;
        vz -= az;
        others[i].vx += ax;
        others[i].vy += ay;
        others[i].vz += az;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    //vz *= friction;
    x += vx;
    y += vy;
    z -= vz;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
    if (z - diameter/2 <= -400) {
      z = -400 + diameter/2;
      vz *= friction; 
    } 
    else if (z + diameter/2 >= 0) {
      z = 0 - diameter/2;
      vz *= friction;
    }
  }
  
  void display() {
      pushMatrix();
      translate(0, 0, z);
      shape(sphere, x, y);
      popMatrix();
  }
}