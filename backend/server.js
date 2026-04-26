const express = require('express');
const cors = require('cors');
const client = require('prom-client');

const app = express();
const port = 3000;

app.use(cors());

client.collectDefaultMetrics();

app.get('/', (req, res) => {
  res.send('Backend Node.js / Express opérationnel');
});

app.get('/api/message', (req, res) => {
  res.json({
    message: 'Bonjour depuis le backend Node.js / Express',
    status: 'success'
  });
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Serveur backend démarré sur le port ${port}`);
});
