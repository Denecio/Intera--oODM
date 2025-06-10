void checkCameras(){
  String[] cameras = Capture.list();
  
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    //println("Available cameras:");
    //printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);

    // Or, the camera name can be retrieved from the list (you need
    // to enter valid a width, height, and frame rate for the camera).
    // cam = new Capture(this, 640, 480, "FaceTime HD Camera (Built-in)", 30);
  }
  
  cam.start();
}

ArrayList<Contour> findCountours(PImage img){
  opencv = new OpenCV(this, img);
  
  opencv.gray();
  opencv.threshold(100); //aumentar este valor se não estiver a dar 
  dst = opencv.getOutput();
  
  return opencv.findContours();
}
