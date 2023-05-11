import express from 'express';
import Keycloak from 'keycloak-connect';

const app = express();

// Middleware configuration loaded from keycloak.json file.
const keycloak = new Keycloak();

app.use(keycloak.middleware());

app.get('/service/public', (req, res) => {
  res.json({message: 'public'});
});

app.get('/service/secured', keycloak.protect('realm:user'), (req, res) => {
  res.json({message: 'secured'});
});

app.get('/service/admin', keycloak.protect('realm:admin'), (req, res) => {
  res.json({message: 'admin'});
});

app.use('*', (req, res) => {
  res.send('Not found!');
});

app.listen(3000, () => {
  console.log('Started at port 3000');
});
