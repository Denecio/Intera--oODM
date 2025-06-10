import processing.video.*;
import processing.pdf.*;
import processing.net.*;
import gab.opencv.*;

OpenCV opencv;
Server myServer;
Client myClient;

PFont book;

Capture cam;
PImage src, dst;

Button saveShapeButton, saveCardButton, menuButton, backButton;

int cardID=0;
boolean drawOnCard = false;

JSONArray currentCard;
JSONArray allShapes;
JSONObject currentShape;
ArrayList<Contour> contours;
Contour largest;

Movie intro;
PGraphics postal;
PImage text, filter1, filter2;
color currentColor;


void setup() {
  //size(640 + 611, 791);
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  myServer = new Server(this, 5204);

  smooth(8);
  
  postal = createGraphics(postalW, postalH);
  allShapes = loadJSONArray("shapes.json");
  text = loadImage("postalText.png");
  filter1 = loadImage("filter1.png");
  filter2 = loadImage("filter2.png");
  intro = new Movie(this, "intro.mp4");
  intro.volume(0.1);
  intro.play();
  
  book = createFont("CooperHewitt-Book.otf", 16, true);
  textFont(book, 16);
  
  checkCameras();
  
  if(!allShapes.isNull(cardID))
    currentCard = allShapes.getJSONArray(cardID);
  else
    currentCard = new JSONArray();
  
  textAlign(CENTER, CENTER);

  saveShapeButton = new Button(width/2 + cam.width/3, cam.height + (height - cam.height)/2, 140, 30, "Guardar Forma");
  saveCardButton = new Button(width/2 + 2 * cam.width/3, cam.height + (height - cam.height)/2, 140, 30, "Exportar Cartão");
  backButton = new Button(width/2 + cam.width/2,  cam.height + (height - cam.height)/2 + 50, 140, 30, "Voltar");
  menuButton = new Button(width/2, height/2 + 100, 140, 30, "Avançar");
}

void draw() {
  checkServer();
  if(drawOnCard){
    mainScreen();
  } else {
    menuScreen();
  }
}

void keyPressed() {
  if(!drawOnCard){
    if (key >= '0' && key <= '9') {
      cardID = cardID * 10 + (key - '0');
    } else if (key == BACKSPACE || key == DELETE) {
      cardID = cardID / 10;
    }
  }
}

void mousePressed() {
  if (drawOnCard) {
    if (saveShapeButton.isMouseOver() && largest != null) {
      saveShape();
    } else if (saveCardButton.isMouseOver()) {
      exportCard();
    } else if (backButton.isMouseOver()) {
      drawOnCard = false;
      cardID = 0;
      intro.jump(0);
      intro.play();
    }
  } else if (menuButton.isMouseOver()) {
    if(cardID == 0) return;
    drawOnCard = true;
    intro.stop();
    if(!allShapes.isNull(cardID))
      currentCard = allShapes.getJSONArray(cardID);
    else
      currentCard = new JSONArray();
  }
}

void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
  someServer.write(allShapes.toString() + "\n");
}

void checkServer(){
  myClient = myServer.available();
  if (myClient == null) {
    return;
  } else {
    String received = myClient.readString();
    allShapes = parseJSONArray(received.trim());
    if(!allShapes.isNull(cardID))
      currentCard = allShapes.getJSONArray(cardID);
    else
      currentCard = new JSONArray();
    saveJSONArray(allShapes, "data/shapes.json");
  }
}
