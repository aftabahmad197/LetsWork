const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./route/user.route');
const cors = require('cors');
const app = express();

app.use(bodyParser.json());

app.use(cors());
app.use('/', userRoutes);

module.exports = app;