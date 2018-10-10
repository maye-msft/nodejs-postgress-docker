


var express = require('express');
var app = express();

const { Pool, Client } = require('pg')
var conString = process.env.DATABASE_URL





/*
 * Hello, world!
 */
app.get('/', function (req, res) {
  res.send('Hello World!');
});


/*
 * Connect to db
 */
app.get('/testdb', function(req, res){
    const client = new Client({
        connectionString: conString,
    })
    client.connect()
    client.query('SELECT NOW()', (err, result) => {
        console.log(err, result)
        res.send(result);
        client.end()
    })
});

/*
 * On server start
 */
var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('Example app listening at http://%s:%s', host, port);
});