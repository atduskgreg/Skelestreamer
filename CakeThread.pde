import postdata.*;

class Skeletor {
  PVector head;
  PVector neck;
  PVector rightShoulder;
  PVector rightElbow;
  PVector rightHand;
  PVector leftShoulder;
  PVector leftElbow;
  PVector leftHand;
  PVector torso;
  PVector rightHip;
  PVector rightKnee;
  PVector rightFoot;
  PVector leftHip;
  PVector leftKnee;
  PVector leftFoot;
  String uuid;

  Skeletor() {
  }

  Skeletor(PVector _head, PVector _neck, PVector _rightShoulder, PVector _rightElbow, PVector _rightHand, PVector _leftShoulder, PVector _leftElbow, PVector _leftHand, PVector _torso, PVector _rightHip, PVector _rightKnee, PVector _rightFoot, PVector _leftHip, PVector _leftKnee, PVector _leftFoot) {
    head          = _head;
    neck          = _neck;
    rightShoulder = _rightShoulder;
    rightElbow    = _rightElbow;
    rightHand     = _rightHand;
    leftShoulder  = _leftShoulder;
    leftElbow     = _leftElbow;
    leftHand      = _leftHand;
    torso         = _torso;
    rightHip      = _rightHip;
    rightKnee     = _rightKnee;
    rightFoot     = _rightFoot;
    leftHip       = _leftHip;
    leftKnee      = _leftKnee;
    leftFoot      = _leftFoot;
  }

  String[] vars() {
    String[] vars = {
      "project", 
      "session", 
      "head", 
      "neck", 
      "rightShoulder", 
      "rightElbow", 
      "rightHand", 
      "leftShoulder", 
      "leftElbow", 
      "leftHand", 
      "torso", 
      "rightHip", 
      "rightKnee", 
      "rightFoot", 
      "leftHip", 
      "leftKnee", 
      "leftFoot"
    };

    return vars;
  }

  String[] vals() {
    String[] vals = {
      "'skelestreamer'", 
      "'" + uuid + "'", 
      "{'x':" + head.x + ", 'y':" + head.y + ",'z':" + head.z + "}", 
      "{'x':" + neck.x + ", 'y':" + neck.y + ",'z':" + neck.z + "}", 
      "{'x':" + rightShoulder.x + ", 'y':" + rightShoulder.y + ",'z':" + rightShoulder.z + "}", 
      "{'x':" + rightElbow.x + ", 'y':" + rightElbow.y + ",'z':" + rightElbow.z + "}", 
      "{'x':" + rightHand.x + ", 'y':" + rightHand.y + ",'z':" + rightHand.z + "}", 
      "{'x':" + leftShoulder.x + ", 'y':" + leftShoulder.y + ",'z':" + leftShoulder.z + "}", 
      "{'x':" + leftElbow.x + ", 'y':" + leftElbow.y + ",'z':" + leftElbow.z + "}", 
      "{'x':" + leftHand.x + ", 'y':" + leftHand.y + ",'z':" + leftHand.z + "}", 
      "{'x':" + torso.x + ", 'y':" + torso.y + ",'z':" + torso.z + "}", 
      "{'x':" + rightHip.x + ", 'y':" + rightHip.y + ",'z':" + rightHip.z + "}", 
      "{'x':" + rightKnee.x + ", 'y':" + rightKnee.y + ",'z':" + rightKnee.z + "}", 
      "{'x':" + rightFoot.x + ", 'y':" + rightFoot.y + ",'z':" + rightFoot.z + "}", 
      "{'x':" + leftHip.x + ", 'y':" + leftHip.y + ",'z':" + leftHip.z + "}", 
      "{'x':" + leftKnee.x + ", 'y':" + leftKnee.y + ",'z':" + leftKnee.z + "}", 
      "{'x':" + leftFoot.x + ", 'y':" + leftFoot.y + ",'z':" + leftFoot.z + "}",
    };
    return vals;
  }

  String toString() {
    String result = "";

    for (int i = 0; i < vars().length; i++) {
      result = result + "{'" + vars()[i] + "' : '" + vals()[i] + "},";
    }
    result = result.substring(1, result.length()-1);
    return result;
  }
}

class CakeThread extends Thread {

  PostData pd;

  boolean running; 

  String url = "http://www.itpcakemix.com/add";
  ArrayList queue; // of skeletors


  CakeThread () {
    running = false;
    pd = new PostData();
    queue = new ArrayList();
  }

  // TODO:
  // - send all enqueued data whenever available
  void postData() {
    int queueSize = queue.size();

    if (queueSize > 0) {

      String[] vars = new String[queueSize];
      String[] vals = new String[queueSize];



      // TODO:
      //- send all frames
      for (int i = 0; i < queueSize; i++) {
        Skeletor toSend = (Skeletor)queue.get(0);
        vars[i] = "" + i + "";
        vals[i] = toSend.toString();
        //pd.post(url, toSend.vars(), toSend.vals());
      }
      
      println("var0: " + vars[0] + " val0: " + vals[0]);

      String code = pd.post( url, vars, vals );


      for (int i = 0; i < queueSize; i++) {
        queue.remove(0);
      }
    }
  }

  // Overriding "start()"
  void start () {
    running = true;
    super.start();
  }

  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {
      try {
        //postData();
      } 
      catch (Exception e) {
        println("something went wrong with cakemix: " + e);
      }
    }
  }


  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // In case the thread is waiting. . .
    interrupt();
  }
}

