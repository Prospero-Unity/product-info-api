const stylesFormatter = (styles, photos, skus) => {
  // Format PHOTOS
  var obj = {};
  photos.forEach((photo) => {
    if (!obj[photo['style_id']]) {
      obj[photo['style_id']] = [{
        thumbnail_url: photo['thumbnail_url'],
        url: photo.url
      }];
    } else {
      obj[photo['style_id']].push({
        thumbnail_url: photo['thumbnail_url'],
        url: photo.url
      });
    }
  });

  photos = obj;

  // FORMAT SKUS
  var obj = {};
  skus.forEach((sku) => {
    if (!obj[sku['style_id']]) {
      obj[sku['style_id']] = {
        [sku.id]: {
          quantity: sku.quantity,
          size: sku.size
        }
      };
    } else {
      obj[sku['style_id']][sku.id] = {
        quantity: sku.quantity,
        size: sku.size
      };
    }
  });

  skus = obj;

  // APPEND PHOTOS AND SKUS TO STYLE
  styles.forEach((style) => {
    style.photos = photos[style['style_id']];
    style.skus = skus[style['style_id']];
  })

  return [styles];
}

module.exports = stylesFormatter;