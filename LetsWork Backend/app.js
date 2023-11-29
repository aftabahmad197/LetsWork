const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./route/user.route');
const CategoryRoutes = require('./route/category.route');
const gigRoutes = require('./route/gig.route');
const jobRoutes = require('./route/job.route');
const cors = require('cors');
const app = express();

app.use(bodyParser.json());

app.use(cors());
app.use('/category', CategoryRoutes);
app.use('/user', userRoutes);
app.use('/gig', gigRoutes);
app.use('/job', jobRoutes);

module.exports = app;