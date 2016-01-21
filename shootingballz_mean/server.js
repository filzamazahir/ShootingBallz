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

var players = []

var server = app.listen(5000, function() {
    console.log("listening on port 5000");
});

var io = require('socket.io').listen(server);
io.sockets.on('connection', function (socket) {


    console.log("SERVER::WE ARE USING SOCKETS!");
    console.log(socket.id);
    // socket.emit("allPlayers", players)
    

    socket.on("newUserConnected", function(data) {
      console.log("user joined in iOS", data);
      players.push(data)
      console.log("Players as of now: ", players);
      // io.sockets.emit("newUserJoinedServer", data);
      io.sockets.emit("updatePlayers", players[0], players[1]);
    });

    socket.on("x", function(data){
    	console.log("Got the x coordinate", data)
    	io.sockets.emit("updateXLocation", data)
    });
    socket.on("y", function(data){
    	console.log("Got the y coordinate", data)
    	io.sockets.emit("updateYLocation", data)
    });

    socket.on("playerOneScored", function(data){
    	console.log("Nice! Player 1", data)
    	io.sockets.emit("updatePlayerOneScore", data)
    });

    socket.on("playerTwoScored", function(data){
    	console.log("Nice! Player 2", data)
    	io.sockets.emit("updatePlayerTwoScore", data)
    });

    // socket.on('disconnect', function() {
    //     console.log('Got disconnect!');
    //     players = []
    // });



});