


var express = require('express');
var app = express();

const { Pool, Client } = require('pg')
var conString = process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost/postgres'





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
    try{
        const client = new Client({
            connectionString: conString,
        })
        client.connect()
        client.query('SELECT NOW()', (err, result) => {
            console.log(err, result)
            res.send(result);
            client.end()
        })
    } catch(err) {
        console.log(err)
        res.send(err);
    }
});

/*
 * On server start
 */

const PORT = process.env.PORT || 8080

var server = app.listen(PORT, () => console.log(`Listening on ${ PORT }`))
