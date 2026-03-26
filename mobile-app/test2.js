const https = require('https');
const fs = require('fs');

https.get('https://nominatim.openstreetmap.org/reverse?format=json&lat=10.762622&lon=106.660172&addressdetails=1', {headers: {'User-Agent': 'KidFavorMobileApp/1.0'}}, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    fs.writeFileSync('output1.json', data);
    console.log('done1');
  });
});

https.get('https://nominatim.openstreetmap.org/reverse?format=json&lat=10.849409&lon=106.753705&addressdetails=1', {headers: {'User-Agent': 'KidFavorMobileApp/1.0'}}, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    fs.writeFileSync('output2.json', data);
    console.log('done2');
  });
});
