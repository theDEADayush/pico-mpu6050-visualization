import processing.serial.*;

Serial myPort;
float roll, pitch, yaw;

void setup() {
  size(1000, 800, P3D);
  smooth(8); // Anti-aliasing for smooth edges
  
  // DEBUG: Print ports to console
  printArray(Serial.list());
  
  try {
    // CHANGE [0] TO [1] IF IT DOESN'T CONNECT!
    String portName = Serial.list()[0]; 
    myPort = new Serial(this, portName, 115200);
    myPort.bufferUntil('\n');
  } 
  catch (Exception e) {
    println("Connection failed. Check Port Index.");
  }
}

void draw() {
  // 1. Black Background
  background(0);
  
  // Lighting
  lights();
  directionalLight(255, 255, 255, -1, 1, -1);
  spotLight(255, 255, 255, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
  
  // HUD Text
  hint(DISABLE_DEPTH_TEST); 
  camera(); 
  noLights();
  fill(0, 255, 0); // Radar Green
  textSize(16);
  text("SYSTEM: ONLINE", 20, 30);
  text("Roll:  " + int(roll) + "°", 20, 60);
  text("Pitch: " + int(pitch) + "°", 20, 80);
  hint(ENABLE_DEPTH_TEST);
  
  translate(width/2, height/2, 0); 
  
  // --- ROTATION MAPPING ---
  // Reversed Pitch (-pitch) for correct flight controls
  rotateX(radians(-pitch)); 
  rotateZ(radians(roll));  
  rotateY(radians(yaw));   
  
  drawPlane();
}

void drawPlane() {
  noStroke();
  
  // Body
  fill(150);
  box(60, 60, 300); 
  
  // Cockpit (Glowing Cyan)
  pushMatrix();
  translate(0, -30, 80);
  fill(0, 255, 255, 200); 
  box(40, 20, 80);
  popMatrix();
  
  // Wings
  pushMatrix();
  translate(0, 0, 50);
  fill(100);
  box(450, 10, 80); 
  popMatrix();
  
  // Tail Vertical
  pushMatrix();
  translate(0, -40, -120);
  fill(200, 0, 0); 
  box(10, 80, 50);
  popMatrix();
  
  // Tail Horizontal
  pushMatrix();
  translate(0, 0, -120);
  fill(100);
  box(140, 10, 40);
  popMatrix();
}

void serialEvent(Serial myPort) {
  try {
    String val = myPort.readStringUntil('\n');
    if (val != null) {
      val = trim(val);
      String[] items = split(val, ',');
      if (items.length == 3) {
        float r = float(items[0]);
        float p = float(items[1]);
        float y = float(items[2]);
        
        if (!Float.isNaN(r) && !Float.isNaN(p)) {
          // High Sensitivity (0.5) for snappy response
          roll  = lerp(roll, r, 0.5);
          pitch = lerp(pitch, p, 0.5);
          yaw   = lerp(yaw, y, 0.5);
        }
      }
    }
  } catch (Exception e) {}
}
