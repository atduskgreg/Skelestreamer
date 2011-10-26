var net = require('net');

var http = require('http');
var gsock;

// client
// http.createServer(function (req, res) {
//   res.writeHead(200, {'Content-Type': 'text/plain'});
//   gsock.on("data", function(data) {
//       console.log(data.toString());
//       res.write(data.toString());
//   })
// }).listen(1338, "127.0.0.1");

// server
var server = net.createServer(function (socket) {
//  socket.write("Echo server\r\n");
        console.log("processing connected");

  socket.pipe(socket);
  
  gsock = socket;
  
  var message = ""; // variable that collects chunks


  
  socket.on("data", function(data) {

  

      //console.log(data.toString());
  })
});
server.listen(1337, "127.0.0.1");

var io = require('socket.io').listen(5000);

io.sockets.on('connection', function (socket) {
  //socket.emit('news', { hello: 'world' });
  console.log("browser connected");
  socket.emit('data', {message : "welcome browser"});
  
  //if(gsock){
    
    var message = "";
    
    gsock.on("data", function(chunk) {
      
       message += chunk;
       //console.log(message);
       
       try {
          json = JSON.parse(message); // let's not get crazy here
          console.log("sending");
          socket.emit("data", json);
          
       } catch (Err) {
           //console.log(message);
           console.log("skipping: " + Err);
           return; // continue
       }
                      message = "";

      //console.log(data.toString());
    });
  //}
});