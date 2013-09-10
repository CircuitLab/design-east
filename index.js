var express = require('express');
var app = express();
var mecab = require('mecab-ffi');
var server = require('http').createServer(app);

var tuiter = require('tuiter');
var keys = require('./keys');
var tu = tuiter(keys);

var io = require('engine.io').attach(server);
var opener = require('opener');

app.set('port', process.env.PORT || 3000);
app.use(express.static(__dirname + '/public'));

io.on('connection', function (socket) {
  console.log("connection");
  tu.search({q:'#de04'}, function(error, tweet){
  if(error) throw error;
  var num = tweet["statuses"].length;
  for(var k=0; k<num; k++) {
    mecab.parse(tweet["statuses"][k].text, function(err, result) {
      //console.log(err, result, tweet.text);
      tweet.segments = result;
      Object.keys(io.clients).forEach(function(key) {
        io.clients[key].send(JSON.stringify(tweet));
      });
    });
  }
 });
});

tu.filter({ track: ['#拡散'] }, function(stream) {
  stream.on('tweet', function(tweet) {
    mecab.parse(tweet.text, function(err, result) {
      // console.log(err, result, tweet.text);
      tweet.segments = result;
      Object.keys(io.clients).forEach(function(key) {
        io.clients[key].send(JSON.stringify(tweet));
      });
    });
  });
});

server.listen(app.get('port'), function() {
  console.log('listening in port %s', app.get('port'));
  opener('http://localhost:' + app.get('port') + '/');
});
