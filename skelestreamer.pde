CakeThread cakeThread;
import fsm.*;

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

FSM recorder;

State setupMode = new State(this, "enterSetup", "doSetup", "exitSetup");
State recordMode = new State(this, "enterRecord", "doRecord", "exitRecord");
State playbackMode = new State(this, "enterPlayback", "doPlayback", "exitPlayback");
State uploadMode = new State(this, "enterUpload", "doUpload", "exitUpload");

boolean readyToRecord = false;

ArrayList queue;

float offset = 0;

int userId;

int currentPlaybackFrame;

String recordingUUID;
IntVector userList;

void setup() {
  size(600, 480);
  recorder = new FSM(setupMode);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  userList = new IntVector();

  enterSetup(); // FSM Bug: it should start by firing off the enter function for the starting state!
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);


  recorder.update();
}

void mousePressed() {
  if (recorder.isInState(setupMode) && readyToRecord) {
    recorder.transitionTo(recordMode);
  } 
  else if (recorder.isInState(recordMode)) {
    recorder.transitionTo(playbackMode);
  }
  else if (recorder.isInState(playbackMode)) {
    recorder.transitionTo(uploadMode);
  }
}

void enterSetup() {
  calculateNewUUID();
    println("entering setup");

}

void doSetup() {
  fill(0);
 
    kinect.getUsers(userList);

  if(userList.size() > 0) {
    userId = userList.get(0);
    if (kinect.isTrackingSkeleton(userId)) {
      readyToRecord = true;
      text("Ready to record.\nUUID: " + recordingUUID, 5, 10);
    } 
    else {
      text("Waiting for user calibration.\nRecording UUID: "+ recordingUUID, 5, 10);
    }
  } 
  else {
    text("Waiting for user.\nRecording UUID: " + recordingUUID, 5, 10);
  }
}

void exitSetup() {
}

void enterRecord() {
  cakeThread = new CakeThread();
  cakeThread.start();
  println("entering record");
}

void doRecord() {
  fill(0);
  text("Recording: "+ recordingUUID +"\nFrames: " + cakeThread.queue.size(), 5, 10);
  drawSkeleton(userId);

  addSkeleton();
  Skeletor last = (Skeletor)cakeThread.queue.get(cakeThread.queue.size() - 1);
}



void exitRecord() {
}

void enterPlayback() {
  currentPlaybackFrame = 0;
      println("entering playback");

}

void doPlayback() {
  fill(0);
  text("Playing: "+ recordingUUID +"\nFrame: " + currentPlaybackFrame + "/" + cakeThread.queue.size(), 5, 10);

  Skeletor last = (Skeletor)cakeThread.queue.get(currentPlaybackFrame);
  ellipse(last.head.x, last.head.y, 10, 10 );

  currentPlaybackFrame++;
  if (currentPlaybackFrame > cakeThread.queue.size() - 1) {
    currentPlaybackFrame = 0;
  }
}

void exitPlayback() {
}

void enterUpload() {
        println("entering upload");

  fill(0);
  text("Uplopading: "+ recordingUUID +"\nFrames: " + cakeThread.queue.size(), 5, 10);
  cakeThread.postData();
}

void doUpload() {
  fill(0);
  text("Uplopading: "+ recordingUUID +"\nFrames: " + cakeThread.queue.size(), 5, 10);
}

void exitUpload() {
}

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

/*
void addSkeleton() {
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
 */


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

