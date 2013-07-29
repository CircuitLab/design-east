
var express = require('express');
var app = express();
var mecab = require('mecab-ffi');
var server = require('http').createServer(app);
var io = require('engine.io').attach(server);

app.use(express.static(__dirname + '/public'));

var tuiter = require('tuiter');
var keys = require('./keys');
var tu = tuiter(keys);

tu.filter({ track: ['#拡散希望'] }, function(stream) {
  stream.on('tweet', function(tweet) {
    mecab.parse(tweet.text, function(err, result) {
      console.log(err, result, tweet.text);
      tweet.segments = result;
      Object.keys(io.clients).forEach(function(key) {
        io.clients[key].send(JSON.stringify(tweet));
      });
    });
  }); 
});

server.listen(3000, function() {
  console.log('listening in port %s', 3000);
});
