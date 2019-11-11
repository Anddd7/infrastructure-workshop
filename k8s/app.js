var redis = require("redis");
var client = redis.createClient("redis://redis:6379");

client.on("connect", function() {
  console.log("connected");
});

client.set("framework", "node", function(err, reply) {
  console.log(reply);
});

client.get("framework", function(err, reply) {
  console.log(reply);
});
