var net = require('net');
var http = require('http');
var io = require('socket.io').listen(5000);

var gsock;

var server = net.createServer(function (socket) {
  console.log("processing connected");
  socket.pipe(socket);
  gsock = socket;
    
  var message = "";

  socket.on("data", function(chunk) {
    message += chunk;
    
    var newlineIndex = message.indexOf('\n');
    if (newlineIndex !== -1) {
        var json = message.slice(0, newlineIndex);
        gsock.emit("json", json);
        message = message.slice(newlineIndex + 1);
    }

  })
});
server.listen(1337, "127.0.0.1");


io.sockets.on('connection', function (socket) {
  console.log("browser connected");
  socket.emit('data', {message : "welcome browser"});
  
    gsock.on("json", function(data) {
       try {
          json = JSON.parse(data);
          console.log("sending");
          socket.emit("data", json);
          
       } catch (Err) {
           console.log("skipping: " + Err);
           return; // continue
       }

    });
});