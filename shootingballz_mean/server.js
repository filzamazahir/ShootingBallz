var express = require("express");
var path = require("path");
var bodyParser = require('body-parser');

var app = express();

app.use(express.static(path.join(__dirname, "./static")));
app.use(bodyParser.urlencoded());

app.set('views', path.join(__dirname, './views'));
app.set('view engine', 'ejs');

app.get('/', function(req, res) {
 res.render("index");
});

var server = app.listen(5000, function() {
 console.log("listening on port 5000");
});

var io = require('socket.io').listen(server);
io.sockets.on('connection', function (socket) {
  console.log("SERVER::WE ARE USING SOCKETS!");
  console.log(socket.id);

    socket.on("newUserConnected", function(data) {
      console.log("user joined in iOS", data);
      io.sockets.emit("newUserJoinedServer", data);
    });

    socket.on("fruitHit", function(data){
    	console.log("Did you make a plane?", data)
    	io.sockets.emit("gotEm", data)
    });

    socket.on("playerOneScored", function(data){
    	console.log("Nice! Player 1", data)
    	io.sockets.emit("updatePlayerOneScore", data)
    })

});