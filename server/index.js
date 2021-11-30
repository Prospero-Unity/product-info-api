const express = require('express');
const db = require('../database');
const app = express();
app.use(express.json());
var port = process.env.PORT || 3000;

app.get('/products', async (req, res) => {
  const { count, page } = req.body;
  try {
    const results = await db.query(`SELECT id, name, slogan, description, category, default_price FROM products WHERE id >= ${page * count} AND id < ${(page + 1) * count}`);
    res.status(200).send(results.rows);
  } catch (err) {
    console.log(err);
    res.sendStatus(400);
  }
});

app.get('/products/:product_id', async (req, res) => {
  try {
    const rows = db.query(`SELECT id, name, slogan, description, category, default_price FROM products WHERE id = ${req.params['product_id']}`);
    const features = db.query(`SELECT feature, value FROM features WHERE product_id = ${req.params['product_id']}`);

    let result = await Promise.all([rows, features]);
    result[0].rows[0].features = result[1].rows;
    res.status(200).send(result[0].rows);
  } catch (err) {
    console.log(err);
    res.sendStatus(400);
  }
});

app.get('/products/:product_id/styles', async (req, res) => {
  var results = req.params;
  try {
    const { rows } = await db.query(`SELECT row_to_json(style) AS results
    FROM (
      SELECT a.style_id, a.name, a.original_price, a.sale_price, a."default\?",
      (SELECT json_agg(photos)
        FROM (
        SELECT photos.url, photos.thumbnail_url FROM photos WHERE photos.style_id = a.style_id)
      photos) AS photos,
     (SELECT json_object_agg(
       s.id, (SELECT json_build_object('quantity', s.quantity, 'size', s.size)
       FROM skus LIMIT 1)
     ) skus
     FROM skus s WHERE s.style_id=a.style_id)
     FROM styles AS a)
      style WHERE style_id=${results['product_id']};`);

    results.results = rows[0].results;
    res.status(200).send(results);
  } catch (err) {
    console.log(err);
    res.sendStatus(400);
  }
});

app.get('/products/:product_id/related', async (req, res) => {
  try {
    const { rows } = await db.query(`SELECT json_agg(related_product_id) FROM related WHERE product_id = ${req.params['product_id']}`);
    res.status(200).send(rows[0]['json_agg']);
  } catch(err) {
    console.log(err);
    res.sendStatus(400);
  }
});


app.listen(port, (err) => {
  if (err) {
    console.log(err);
  } else {
    console.log(`listening on port ${port}`);
  }
});