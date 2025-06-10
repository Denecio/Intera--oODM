class Button{
    int x, y, w, h;
    String label;

    Button(int x, int y, int w, int h, String label){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label;
    }

    boolean isMouseOver(){
        return mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2;
    }

    void display(){
        if(isMouseOver()){
            fill(340);
            strokeWeight(2);
        } else {
            fill(360);
            strokeWeight(1);
        }
        rectMode(CENTER);
        stroke(0);
        rect(x, y, w, h);
        fill(0);
        textAlign(CENTER, CENTER);
        text(label, x, y);
    }
}