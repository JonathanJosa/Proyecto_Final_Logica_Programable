class Gallina{
  
  PImage[] movimientoI;
  PImage[] movimientoD;
  String PATH = "./assets/gallina/";
  PVector pos;
  int mov = 0;
  int DELAY = 3;
  int delayMov = 0;
  
  Gallina(){
    pos = new PVector(1440, 500);
    movimientoI = new PImage[10];
    movimientoD = new PImage[10];
    for(int i=0; i<6; i++){
      movimientoI[i] = loadImage(PATH + "izquierda" + i + ".png");
      movimientoD[i] = loadImage(PATH + "derecha" + i + ".png");
    }
    
  }
  
  void display(boolean move){
    if(delayMov == 0){
      int temp = -1;
      if(move) temp = 1;
      pos.x = pos.x + (6 * temp);
      if(pos.x >= 1440) pos.x = 20;
      if(pos.x <= 0) pos.x = 1420;
      mov = (mov + 1) % 6;
    }
    if(move){
      image(movimientoD[mov], pos.x, pos.y, 100, 100);
    }else{
      image(movimientoI[mov], pos.x, pos.y, 100, 100);
    }
    delayMov = (delayMov + 1) % DELAY;
  }
  
  boolean collision(PVector playerPos){
    return ((playerPos.x >= pos.x-20 && playerPos.x <= pos.x+80) && playerPos.y == 520);
  }
  
}
