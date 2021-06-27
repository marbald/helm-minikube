// declare dependencies
const http = require('http');
const { Pool, Client } = require('pg')
const express = require('express');
const app = express();

const hostname = '0.0.0.0'
const port = 3000;

// start listener on port
app.listen(port, hostname, function() {
  console.log('Node.js server listening on port ' + port)
})

// declare get listener on '/'
app.get('/app', function(req, res) {

  console.log('GET has been called')

  // declare psql pool
  const pool = new Pool()
  
  // query the database and prepare db_response
  pool.query('SELECT readme FROM HELLOWORLD', (err, resp) => {

    try {
      db_response = JSON.parse(JSON.stringify(resp))
      pool.end()
      res.send(db_response.rows[0].readme)
    } catch (e) {
      console.log('[ERR] returned db string > ', resp)
      console.log('[ERR] with db err > ', err)
      res.send("An error occurred, please check the pod logs")
    }

  })

})
