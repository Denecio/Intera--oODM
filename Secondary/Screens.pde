void mainScreen(){
  background(51, 70, 89);
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, width-100-cam.width, 100);

  saveShapeButton.display();
  saveCardButton.display();
  backButton.display();
  
  postal.beginDraw();
  postal.background(255);
  drawPreviousShapes(postal, currentCard);
  
  contours = findCountours(cam);
  
  if(contours.size() > 1){
    contours.remove(contours.size()-1);
    largest = contours.get(0);
    float maxArea = largest.area();

    for (Contour c : contours) {
      float area = c.area();
      if (area < 1000) continue;
      if (area > maxArea) {
        maxArea = area;
        largest = c;
      }
    }
    
    drawCurrentShape(postal, largest, cam);
  }
  postal.image(text, 0, 0, postalW, postalH);
  postal.endDraw();
  image(postal, 100, height/2-postalH/2, postalW, postalH);
}

void menuScreen(){
  background(360);
  if(intro.available()){
    intro.read();
  }
  image(intro, 0, 0, width, height);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  if(intro.time() >= 11.31){
    if(cardID != 0)
      text(cardID, width/2, height/2 + 50);
    menuButton.display();
  }
}