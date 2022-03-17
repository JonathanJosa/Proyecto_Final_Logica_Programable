class Snake{
  
  PImage[] movimiento; 
  String PATH = "./assets/snake/";
  int movState;
  int delayMov = 0;
  int DELAY = 5;
  int posX;
  int speed;
 
  Snake(){
    movimiento = new PImage[10];
    for(int i=0; i<10; i++){
      movimiento[i] = loadImage(PATH + i + ".png");
    }
    posX = 1450;
    speed = int(random(2, 10));
  }
  
  int appear(){
    return int(random(10, 500));
  }
  
  boolean display(){
    if (delayMov == 0){
      posX = posX - speed;
      movState = (movState + 1) % 10;
     }
    image(movimiento[movState], posX, 445);
    delayMov = (delayMov + 1) % DELAY;
    if(posX <= -200){return true;}
    return false;
  }
  
  boolean collision(PVector playerPos){
    return ((playerPos.x >= posX+60 && playerPos.x <= posX+140) && playerPos.y == 520);
  }
  
}
