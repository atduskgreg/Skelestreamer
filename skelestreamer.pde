import processing.net.*;
import SimpleOpenNI.*;
import fsm.*;

SimpleOpenNI  kinect;
FSM app;

CakeThread cakeThread;
String recordingUUID;

State setupMode = new State(this, "enterSetup", "doSetup", "exitSetup");
State streamMode = new State(this, "enterStream", "doStream", "exitStream");

boolean readyToStream = false;

int userId;
IntVector userList;


void setup() {
  size(640,480);

 // frameRate(30);

  app = new FSM(setupMode);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  userList = new IntVector();
  enterSetup(); // FSM Bug: it should start by firing off the enter function for the starting state!


}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);  
  app.update();
  //text(frameRate, 10,10);
 // addSkeleton();
}

void mousePressed() {
  if (app.isInState(setupMode) && readyToStream) {
    app.transitionTo(streamMode);
  } 
}

void enterSetup() {
  calculateNewUUID();
    println("entering setup");
}

void doSetup() {
  fill(0, 255,0);
   textSize(30);

    kinect.getUsers(userList);

  if(userList.size() > 0) {
    userId = userList.get(0);
    if (kinect.isTrackingSkeleton(userId)) {
      readyToStream = true;
      text("Ready to stream.\nUUID: " + recordingUUID, 5, 25);
    } 
    else {
      text("Waiting for user calibration.\tUUID: "+ recordingUUID, 5, 25);
    }
  } 
  else {
    text("Waiting for user.\tUUID: " + recordingUUID, 5, 25);
  }
}

void exitSetup() {
}

void enterStream() {
  cakeThread = new CakeThread(this);
  cakeThread.start();
  println("entering stream");
}

void doStream() {
  fill(0, 255,0);
  textSize(30);
  text("Streaming: "+ recordingUUID + "\nQueueSize: " + cakeThread.queue.size(), 5, 25);

  drawSkeleton(userId);

  addSkeleton();
  //Skeletor last = (Skeletor)cakeThread.queue.get(cakeThread.queue.size() - 1);
    println(cakeThread.queue.size());

}

void exitStream(){}

void calculateNewUUID() {
  recordingUUID = "SK" + random(100) + "A" + random(100) + "A" + random(100) + "A";
  println(recordingUUID);
}


void addSkeleton() {
  PVector head = new PVector();
  PVector neck = new PVector();
  PVector rightShoulder = new PVector();
  PVector rightElbow = new PVector();
  PVector rightHand = new PVector();
  PVector leftShoulder = new PVector();
  PVector leftElbow = new PVector();
  PVector leftHand = new PVector();
  PVector torso = new PVector();
  PVector rightHip = new PVector();
  PVector rightKnee = new PVector();
  PVector rightFoot = new PVector();
  PVector leftHip = new PVector();
  PVector leftKnee = new PVector();
  PVector leftFoot = new PVector();

  kinect.getJointPositionSkeleton(userId, kinect.SKEL_HEAD, head);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_NECK, neck);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_SHOULDER, rightShoulder);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_ELBOW, rightElbow);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_HAND, rightHand);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_SHOULDER, leftShoulder);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_ELBOW, leftElbow);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_HAND, leftHand);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_TORSO, torso);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_HIP, rightHip);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_KNEE, rightKnee);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_RIGHT_FOOT, rightFoot);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_HIP, leftHip);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_KNEE, leftKnee);
  kinect.getJointPositionSkeleton(userId, kinect.SKEL_LEFT_FOOT, leftFoot);


  Skeletor skel = new Skeletor();
  skel.head = head;
  skel.neck =  neck;
  skel.rightShoulder = rightShoulder;
  skel.rightElbow =  rightElbow;
  skel.rightHand =  rightHand;
  skel.leftShoulder =  leftShoulder;
  skel.leftElbow =  leftElbow;
  skel.leftHand =  leftHand;
  skel.torso =  torso;
  skel.rightHip =  rightHip;
  skel.rightKnee = rightKnee; 
  skel.rightFoot = rightFoot; 
  skel.leftHip =  leftHip;
  skel.leftKnee =  leftKnee;
  skel.leftFoot = leftFoot;

  skel.uuid = recordingUUID;

  cakeThread.queue.add(skel);
}

void fakeSkeleton() {
  Skeletor skel = new Skeletor();
  skel.head = new PVector(random(1000), random(1000), random(1000));
  skel.neck =  new PVector(random(1000), random(1000), random(1000));
  skel.rightShoulder = new PVector(random(1000), random(1000), random(1000));
  skel.rightElbow =  new PVector(random(1000), random(1000), random(1000));
  skel.rightHand =  new PVector(random(1000), random(1000), random(1000));
  skel.leftShoulder =  new PVector(random(1000), random(1000), random(1000));
  skel.leftElbow =  new PVector(random(1000), random(1000), random(1000));
  skel.leftHand =  new PVector(random(1000), random(1000), random(1000));
  skel.torso =  new PVector(random(1000), random(1000), random(1000));
  skel.rightHip =  new PVector(random(1000), random(1000), random(1000));
  skel.rightKnee = new PVector(random(1000), random(1000), random(1000)); 
  skel.rightFoot = new PVector(random(1000), random(1000), random(1000)); 
  skel.leftHip =  new PVector(random(1000), random(1000), random(1000));
  skel.leftKnee =  new PVector(random(1000), random(1000), random(1000));
  skel.leftFoot =new PVector(random(1000), random(1000), random(1000));

  skel.uuid = recordingUUID;

  cakeThread.queue.add(skel);
}

void drawSkeleton(int userId) {
  stroke(0);
  strokeWeight(5);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

  noStroke();

  fill(255, 0, 0);
  drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);
  if (confidence < 0.5) {
    return;
  }
  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);
  ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}


// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}


