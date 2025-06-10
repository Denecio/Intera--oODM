int postalW = 611;
int postalH = 791;  
int offset = 4;

void drawCurrentShape(PGraphics canvas, Contour contour, PImage src){
  pushMatrix();
    translate(width-100-cam.width, 100);
    strokeWeight(3);
    stroke(360, 100, 100);
    noFill();
    contour.draw();
  popMatrix();

  ArrayList <PVector> points = contour.getPolygonApproximation().getPoints();
  if (points.size() < 3) {
    return; // Not enough points to form a shape
  }
  float x=0, y=0;
  
  for (PVector point : points) {
    x += point.x;
    y += point.y;
  }
  
  x = x/points.size();
  y = y/points.size();
  
  currentColor = src.get(int(x),int(y));
  //give some brightness to the color
  currentColor = color(hue(currentColor), saturation(currentColor), brightness(currentColor) + 10);

  PGraphics shadowLayer = createGraphics(postalW, postalH);
  shadowLayer.beginDraw();
  shadowLayer.clear();
  shadowLayer.beginShape();
  shadowLayer.noStroke();
  shadowLayer.fill(150, 50); // Semi-transparent gray for shadow
  for (PVector point : points) {
    shadowLayer.vertex(map(point.x, 0 , cam.width, offset, postalW + offset), map(point.y, 0, cam.height, offset, postalH + offset));
  }
  shadowLayer.endShape();
  shadowLayer.filter(BLUR, 2);
  shadowLayer.endDraw();
  canvas.image(shadowLayer, 0, 0);
  canvas.noStroke();
  canvas.fill(currentColor);
  
  canvas.beginShape();
  for (PVector point : points) {
    canvas.vertex(map(point.x, 0 , cam.width, 0, postalW), map(point.y, 0, cam.height, 0, postalH));
  }
  canvas.endShape();
  
}

void drawPreviousShapes(PGraphics canvas, JSONArray shapes){
  for(int i = 0; i < shapes.size(); i++){
    JSONObject shape = shapes.getJSONObject(i);
    
    JSONObject colorValues = shape.getJSONObject("cor");
    
    color c = color(colorValues.getInt("h"), colorValues.getInt("s"), colorValues.getInt("b"));
    
    JSONArray points = shape.getJSONArray("points");
    
    PGraphics shadowLayer = createGraphics(postalW, postalH);

    shadowLayer.beginDraw();
    shadowLayer.clear();
    shadowLayer.beginShape();
    shadowLayer.noStroke();
    shadowLayer.fill(0, 0, 25, 50);
    for(int j = 0; j < points.size(); j++){
      JSONObject point = points.getJSONObject(j);
      shadowLayer.vertex(point.getFloat("x") + offset, point.getFloat("y") + offset);
    }
    shadowLayer.endShape();
    shadowLayer.filter(BLUR, 2);
    shadowLayer.endDraw();

    canvas.image(shadowLayer.get(), 0, 0);
    canvas.noStroke();
    canvas.fill(c);
    canvas.beginShape();
    for(int j = 0; j < points.size(); j++){
      JSONObject point = points.getJSONObject(j);
      canvas.vertex(point.getFloat("x"), point.getFloat("y"));
    }
    canvas.endShape();
  }
}
