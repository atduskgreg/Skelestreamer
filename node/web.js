var net = require('net');
var http = require('http');
var io = require('socket.io').listen(5000);

var gsock;

var server = net.createServer(function (socket) {
  console.log("processing connected");
  socket.pipe(socket);
  gsock = socket;
    
  socket.on("data", function(data) {
  })
});
server.listen(1337, "127.0.0.1");


io.sockets.on('connection', function (socket) {
  console.log("browser connected");
  socket.emit('data', {message : "welcome browser"});
  
    
    var message = "";
    
    gsock.on("data", function(chunk) {
      
       message += chunk;
       
       try {
          json = JSON.parse(message); // let's not get crazy here
          console.log("sending");
          socket.emit("data", json);
          
       } catch (Err) {
           console.log("skipping: " + Err);
           return; // continue
       }
       message = "";

    });
});