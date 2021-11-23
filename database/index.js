const {Pool} = require('pg');
const db = new Pool({
  user: "docker",
  password: "123456",
  host: "db",
  database: "product_info"
});


db.connect((err) => {
  if (err) {
    console.log(err);
  } else {
    console.log('connected on 8000');
  }
});


module.exports = db;
