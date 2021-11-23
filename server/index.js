const express = require('express');
const db = require('../database');
const stylesFormatter = require('../stylesFormatter.js');
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
    res.status(200).send('this is working');
    // res.sendStatus(400);
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
    const { rows } = await db.query(`SELECT style_id, name, original_price, sale_price, "default?" FROM styles WHERE product_id = ${results['product_id']}`);
    var styleIds = rows.map(style => style['style_id']);

    var photos = db.query(`SELECT json_agg(json_build_object('style_id', style_id, 'thumbnail_url', thumbnail_url, 'url' , url)) AS photos FROM photos WHERE style_id >= ${styleIds[0]} AND style_id <= ${styleIds[styleIds.length - 1]}`);

    var skus = db.query(`SELECT * FROM skus WHERE style_id >= ${styleIds[0]} AND style_id <= ${styleIds[styleIds.length - 1]}`);

    let style = await Promise.all([photos, skus]);
    photos = style[0].rows[0].photos;
    skus = style[1].rows;

    results.results = stylesFormatter(rows, photos, skus);
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