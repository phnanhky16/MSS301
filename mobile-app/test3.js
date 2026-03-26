const https = require('https');
const fs = require('fs');

https.get('https://nominatim.openstreetmap.org/reverse?format=json&lat=21.028511&lon=105.804817&addressdetails=1', {headers: {'User-Agent': 'KidFavorMobileApp/1.0'}}, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    fs.writeFileSync('output3.json', data);
    console.log('done3');
  });
});
