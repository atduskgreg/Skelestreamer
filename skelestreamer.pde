import processing.net.*;

CakeThread cakeThread;
String recordingUUID;


void setup() {
  size(500,500);
  cakeThread = new CakeThread(this);
  cakeThread.start();
  frameRate(30);
  calculateNewUUID();
}

void draw() {
  background(0);
  text(frameRate, 10,10);
  println(cakeThread.queue.size());
  addSkeleton();
}

void calculateNewUUID() {
  recordingUUID = "SK" + random(100) + "A" + random(100) + "A" + random(100) + "A";
  println(recordingUUID);
}

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

