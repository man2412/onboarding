const fs = require('fs');
const http = require('http');
const WebSocket = require('ws');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Log Viewer Server\n');
});

const wss = new WebSocket.Server({ server });

const logPath = 'C:\\Users\\manav\\Desktop\\generate_logs.txt';

let lastModified = 0;
let lastReadPosition = 0;

function tail(client) {
  const stream = fs.createReadStream(logPath, { encoding: 'utf-8', start: lastReadPosition });

  stream.on('data', (chunk) => {
    client.send(chunk);
  });

  stream.on('end', () => {
    lastReadPosition = fs.statSync(logPath).size;
  });
}

function sendLast10Lines(client) {
  const fileText = fs.readFileSync(logPath, 'utf-8');
  const lines = fileText.split('\n').slice(-10).join('\n');
  client.send(lines);
}

wss.on('connection', (ws) => {
  // Send the last 10 lines when a client connects
  sendLast10Lines(ws);
});

setInterval(() => {
  const currentModified = fs.statSync(logPath).mtimeMs;
  if (currentModified > lastModified) {
    // Iterate over clients and send updates
    wss.clients.forEach((client) => {
      tail(client);
    });
    lastModified = currentModified;
  }
}, 1000);

server.listen(8765, () => {
  console.log('Server listening on http://localhost:8765');
});

