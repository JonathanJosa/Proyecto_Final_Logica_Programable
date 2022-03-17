import processing.serial.*;   

Serial port;
int val;
int last_v; 
int cont;
int realVal;

Player p1;
Snake[] snakes;
Snake[] snakesTemp;
Player lst;
boolean alreadyDead = false;

int[] snakeAppear;
int[] snakeAppearTemp;

PImage back;
PImage ground;
PImage platform; // 251 x 156

String path;
int definedPress;
boolean[] keysPressed;
PVector pos;

void setup(){  
  size(1440, 720);
  path = "./assets/";
  back = loadImage(path + "sky.png");
  ground = loadImage(path + "ground.png");
  platform = loadImage(path + "platform.png");
  p1 = new Player();
  
  keysPressed = new boolean[4];
  definedPress = 0;
  
  snakes = new Snake[3];
  snakeAppear = new int[snakes.length];
  for(int i=0; i<snakes.length; i++){
    snakes[i] = new Snake();
    snakeAppear[i] = snakes[i].appear();
  }
  
  last_v = 110;
  cont = 0;
  last_v = 1;
  port = new Serial(this, "COM9", 115200);
  
}

void draw(){   
  
  image(back, 0, 0);
  image(platform, -70, 375);
  image(platform, 400, 475);
  image(platform, 1000, 475);
  image(ground, 0, 720-195);
  
  for(int i=0; i<snakes.length; i++){
    if(snakeAppear[i] > 0){
      snakeAppear[i] -= 1;
    }else if(snakes[i].display()){
      snakes[i] = new Snake();
      snakeAppear[i] = snakes[i].appear();
    }else if(snakes[i].collision(pos)){
      p1.muertado();
      lst = p1;
      p1 = new Player();
      alreadyDead = true;
    }
  }
  
  boolean flag = false;
  for(int i=0; i<4; i++){
    if(keysPressed[i]){
      pos = p1.display(i+1);
      flag = true;
    }
  }
  if(!flag){
    pos = p1.display(0);
  }
  
  if(alreadyDead) lst.display(0);
  
  moves();
  ports();
  
}

/*
void keyPressed() {
  switch(keyCode) {
    case RIGHT: keysPressed[0] = true; break;
    case LEFT: keysPressed[1] = true; break;
    case UP: keysPressed[2] = true; break;
    case DOWN: keysPressed[3] = true; break;
  }
}
void keyReleased() {
  switch(keyCode) {
    case RIGHT: keysPressed[0] = false; break;
    case LEFT: keysPressed[1] = false; break;
    case UP: keysPressed[2] = false; break;
    case DOWN: keysPressed[3] = false; break;
  }
}
*/

void moves(){
  switch(last_v) {
    case 100: keysPressed[0] = true; break;
    case 97: keysPressed[1] = true; break;
    case 119: keysPressed[2] = true; break;
    case 110: keysPressed[0] = false; keysPressed[1] = false;  keysPressed[2] = false;   
  }
}

void ports() { 
  if (0 < port.available()) {  
    val = port.read();
    cont = (cont+1) % 10;
  }
  if(val != last_v && val != 110){
    realVal = val;
  }
  if(realVal != last_v && cont == 0){
    last_v = realVal;
  }
} 
