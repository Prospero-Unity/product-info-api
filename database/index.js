const {Pool} = require('pg');
const db = new Pool({
  user: "docker",
  password: "123456",
  host: "localhost",
  database: "product_info",
  port: 5432
});


db.connect((err) => {
  if (err) {
    console.log(err);
  } else {
    console.log('connected on 5432');
  }
});


module.exports = db;
