const fs = require('fs');
const path = require('path');

// Get environment variable or default to localhost:4292
const apiTarget = process.env.API_TARGET || 'http://localhost:4292';

const proxyConfig = {
  "/api": {
    "target": apiTarget,
    "secure": false
  }
};

// Write the proxy config to the appropriate directory
const proxyFilePath = path.join(__dirname, 'proxy.conf.json');
fs.writeFileSync(proxyFilePath, JSON.stringify(proxyConfig, null, 2));

console.log(`Proxy configuration generated with target: ${apiTarget}`);
