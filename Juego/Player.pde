class Player{
  
  PImage[] movimiento;
  
  PVector pos;
  int movState;
  
  float contador = 5;
  int delayMov = 0;
  boolean dead = false;
  boolean saltando = false;

  int DELAY = 5;
  String PATH = "./assets/huevo/";
  int init = 15;
  
  Player(){
    pos = new PVector(-60, 350);
    movimiento = new PImage[19];
    for(int i=0; i<movimiento.length; i++){
      movimiento[i] = loadImage(PATH + "pos" + i + ".png");
    }
  }
  
  PVector display(int type){
    if (delayMov == 0){
      if(init > 0){ init -= 1; type = 1; }
      if(dead){endPlayer(); delayMov = 1; return pos;}
      switch (type){
        case 0: movState = 0; break;
        case 1: movState = (movState + 1) % 5; pos.x = pos.x + 8; break;
        case 2: movState = (movState + 4) % 5; pos.x = pos.x - 8; break;
        case 3: saltando = true; break;
        case 4: movState = 6; pos.y = pos.y + 26; break;
      }
      if(pos.x <= -35 && pos.y != 350) pos.x = 1420;
      if(pos.x >= 1440) pos.x = -35;
      if (saltando) {salto();}
      else{gravedad();}
     }
    image(movimiento[movState], pos.x, pos.y);
    delayMov = (delayMov + 1) % DELAY;
    return pos;
  }
  
  void salto(){
    contador += 0.7;
    if (contador < 10){
      pos.y = pos.y - 20;
    }else{
      gravedad();
    }
    movState = int(contador);
    if (contador >= 14){
      saltando = false;
      contador = 5;
    }
  }
  
  void gravedad(){
    if((pos.x >= -100 && pos.x <= 147) && (pos.y >= 345 && pos.y <= 375)){
      pos.y = 350;
    }else if(((pos.x >= 377 && pos.x <= 625) || (pos.x >= 977 && pos.x <= 1225)) && (pos.y >= 445 && pos.y <= 475)){
      pos.y = 450;
    }else if(pos.y > 520){
      pos.y = 520; 
    }else if(pos.y < 520){
      pos.y = pos.y + 20;
      if(!saltando) movState = 12;
    }
  }
  
  void muertado(){
    dead = true;
    movState = max(14, movState);
  }
  
  void endPlayer(){
    movState += 1;
    movState = min(18, movState);
    image(movimiento[movState], pos.x, pos.y);
  }
  
}
