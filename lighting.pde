PShape walls, chair, table, skyBox;
PImage wallTexture, skyTexture, floorTexture, tableTexture, chairTexture;
int rotationX, rotationY, angleX, angleY, lightChoice;
float cameraZ, cameraDespX, cameraDespY, cameraDespZ, cameraX, cameraY, cameraLookAtX, cameraLookAtY, cameraLookAtZ, upY;
final String[] lightType = {"Default light", "Ambient light (light pink)", "Point light (light blue)", "Spotlight (wine)", "Directional light (light red)"};
final String controlsText = "Use WS to move forward and backwards\n" + "Use AD to move sideways\n" + "Use CZ to move down and up\n" + "Use QE to rotate sideways\n" + "Use SHIFT and CONTROL to rotate vertically\n" + "To control the lighting press L\n" + "Press ENTER to start the simulation"; 
boolean simulation;

void setup(){
  size(800, 800, P3D);
  initImages();
  generateSkyBox();
  generateWalls();
  generateTable();
  generateChair();
  lightChoice = 0;
  textSize(24);
  textAlign(CENTER);
  simulation = false;
  reset();
}

void initImages(){
  wallTexture = loadImage("brick_wall.jpeg");
  skyTexture = loadImage("sky.jpg");
  floorTexture = loadImage("floor.jpg");
  tableTexture = loadImage("table.jpg");
  chairTexture = loadImage("chair.jpg");
}

void reset(){
  cameraX = 0;
  cameraY = -200;
  cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  cameraLookAtX = 0;
  cameraLookAtY = -20;
  cameraLookAtZ = 0;
  angleX = 0;
  angleY = 0;
}

void keyPressed(){
  if (key == 'a') cameraDespX = -1;
  else if (key == 'd') cameraDespX = +1;
  else if (key == 's') cameraDespZ = +1;
  else if (key == 'w') cameraDespZ = -1;
  else if (key == 'c') cameraDespY = +1;
  else if (key == 'z') cameraDespY = -1;
  else if (key == 'r') reset();
  else if (key == 'q') rotationX = 2;
  else if (key == 'e') rotationX = -2;
  else if (key == 'l') swapLight();
  else if (keyCode == CONTROL) rotationY = 2;
  else if (keyCode == SHIFT) rotationY = -2;
  else if (keyCode == ENTER) simulation = true;
}

void keyReleased(){
  if (key == 'a' || key == 'd') cameraDespX = 0;
  else if (key == 'w' || key == 's') cameraDespZ = 0;
  else if (key == 'c' || key == 'z') cameraDespY = 0;
  else if (key == 'q' || key == 'e') rotationX = 0;
  else if (keyCode == CONTROL || keyCode == SHIFT) rotationY = 0;
}

void swapLight(){
  lightChoice++;
  if (lightChoice == 5) lightChoice = 0;
}

void generateSkyBox(){
  skyBox = createShape(SPHERE, 4000);  
  skyBox.setTexture(skyTexture);
  skyBox.setStroke(false);
}

void generateWalls(){
  walls = createShape(GROUP);
  addWalls();
}

void generateTable(){
  table = createShape(GROUP);
  addLegs(table, 20);
  addTableTop();
  table.setTexture(tableTexture);
  table.translate(0, 20, -100);
}

void generateChair(){
  chair = createShape(GROUP);
  addLegs(chair, 10);
  addChairTop();
  chair.setTexture(chairTexture);
  chair.translate(0, 25, -50);
}

void addChairTop(){
  PShape chairTop;
  chairTop = createShape(BOX, 25, 3, 25);
  chairTop.translate(0, -5);
  chair.addChild(chairTop);  
}

void addTableTop(){
  PShape tableTop;
  tableTop = createShape(BOX, 50, 3, 50);
  tableTop.translate(0, -10);
  table.addChild(tableTop);  
}

void addLegs(PShape shape, int size){
  PShape leg;
  leg = generateLeg(size);
  leg.translate(size, 0, size);
  shape.addChild(leg);
  leg = generateLeg(size);
  leg.translate(-size, 0, size);
  shape.addChild(leg);
  leg = generateLeg(size);
  leg.translate(size, 0, -size);
  shape.addChild(leg);
  leg = generateLeg(size);
  leg.translate(-size, 0, -size);
  shape.addChild(leg);
}

PShape generateLeg(int h){
  return createShape(BOX, 5, h, 5);
}

PShape generateWallHor(){
  return createShape(BOX, 600, 120, 20);
}

PShape generateWallVer(){
  return createShape(BOX, 20, 120, 600);
}


void addWalls(){
  PShape wall, floor;
  int offset = 300;
  wall = generateWallHor();
  wall.translate(0, 0, -offset);
  wall.setTexture(wallTexture);
  walls.addChild(wall);
  wall = generateWallHor();
  wall.translate(0, 0, offset);
  wall.setTexture(wallTexture);
  walls.addChild(wall);
  wall = generateWallVer();
  wall.translate(offset, 0, 0);
  wall.setTexture(wallTexture);
  walls.addChild(wall);
  wall = generateWallVer();
  wall.translate(-offset, 0, 0);
  wall.setTexture(wallTexture);
  walls.addChild(wall);
  fill(200, 200, 200);
  floor = createShape(BOX, 600, 10, 600);
  floor.translate(0, 35, 0);
  floor.setTexture(floorTexture);
  walls.addChild(floor);
}

void setLookAtPoint(){
  angleX += rotationX;
  angleY += rotationY;
  cameraLookAtX = cameraLookAtX + cameraDespX * cos(radians(angleX)) + cameraDespZ * sin(radians(angleX)) * cos(radians(angleY))
  + cameraDespY * sin(radians(angleY)) * sin(radians(angleX));
  cameraLookAtY = cameraLookAtY + cameraDespY * cos(radians(angleY)) - cameraDespZ * sin(radians(angleY));
  cameraLookAtZ = cameraLookAtZ - cameraDespX * sin(radians(angleX)) + cameraDespZ * cos(radians(angleX)) * cos(radians(angleY))
  + cameraDespY * sin(radians(angleY)) * cos(radians(angleX));
}

void setCamera(){
  cameraX = cameraLookAtX + 100 * sin(radians(angleX)) * cos(radians(angleY));
  cameraY = cameraLookAtY - 100 * sin(radians(angleY));
  cameraZ = cameraLookAtZ + 100 * cos(radians(angleX)) * cos(radians(angleY));
  
  if (abs(angleY + 90) % 360 == 180) camera(cameraX, cameraY, cameraZ, cameraLookAtX, cameraLookAtY, cameraLookAtZ, sin(radians(angleX)), 0, cos(radians(angleX)));
  else if (abs(angleY + 90) % 360 == 0) camera(cameraX, cameraY, cameraZ, cameraLookAtX, cameraLookAtY, cameraLookAtZ, -sin(radians(angleX)), 0, -cos(radians(angleX)));
  else {
    upY = round(1 * (cos(radians(angleY))/abs(cos(radians(angleY)))));
    camera(cameraX, cameraY, cameraZ, cameraLookAtX, cameraLookAtY, cameraLookAtZ, 0, upY, 0);
  }
}

void setLight(){
  switch(lightChoice){
    case 0:
      lights();
      break;
    case 1:
      ambientLight(221, 140, 223);
      break;
    case 2:
      pointLight(190, 219, 230, 0, -200, 0);
      break;
    case 3:
      spotLight(128, 62, 86, 0, -200, 0, 0, 1, 0, radians(90), 0.5);
      break;
    case 4:
      directionalLight(241, 126, 124, 0, 1, 0);
      break;
  }
}

void setText(){
  if (lightChoice != 4) text(lightType[lightChoice] + "\nPress L to change lights", 0, -20, -287);
  else {
    pushMatrix();
    rotateX(PI/3.);
    text(lightType[lightChoice] + "\nPress L to change lights", 0, -222, -28);
    popMatrix();
  }
}


void draw(){
  if (simulation){
    setLight();
    println(cameraX, cameraY, cameraZ);
    shape(skyBox);
    shape(walls);
    shape(table);
    shape(chair);
    setLookAtPoint();
    setCamera();  
    setText();
  } else { 
    background(128);
    text(controlsText, width/2, height/3);
  }
}
