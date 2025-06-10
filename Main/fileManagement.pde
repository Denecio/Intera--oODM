void saveShape(){
  currentShape = shapeToJSON(largest, currentColor);
  
  currentCard.append(currentShape);
  
  allShapes.setJSONArray(cardID, currentCard);
  
  saveJSONArray(allShapes, "data/shapes.json");
  
  myServer.write(allShapes.toString() + "\n"); // Send the array as a string
  println("Sent JSON array to client");
}

JSONObject shapeToJSON(Contour contour, color c){
  JSONObject newShape = new JSONObject();
  
  JSONObject cor = new JSONObject();
  cor.setFloat("h", hue(c));
  cor.setFloat("s", saturation(c));
  cor.setFloat("b", brightness(c));
  
  JSONArray points = new JSONArray();
  ArrayList <PVector> ps = contour.getPolygonApproximation().getPoints();
  
  for(int i=0; i<ps.size(); i++){
    PVector p = ps.get(i);
    JSONObject point = new JSONObject();
    
    point.setFloat("x", map(p.x, 0 , cam.width, 0, 611));
    point.setFloat("y", map(p.y, 0, cam.height, 0, 791));

    for(int j=0; j<points.size(); j++){
      JSONObject otherPoint = points.getJSONObject(j);
      if(abs(point.getFloat("x") - otherPoint.getFloat("x")) <= 5 && abs(point.getFloat("y") - otherPoint.getFloat("y")) <= 5){
        break;
      }
    }

    points.setJSONObject(i, point);
  }
  
  newShape.setJSONObject("cor",cor);
  newShape.setJSONArray("points",points);
  
  return newShape;
}

void exportCard(){
  PGraphics card = createGraphics(postalW, postalH, PDF, "data/cards/card" + cardID + ".pdf");
  card.beginDraw();
  card.background(255);
  drawPreviousShapes(card, currentCard);
  card.image(text, 0, 0, postalW, postalH);
  card.dispose();
  card.endDraw();
}
