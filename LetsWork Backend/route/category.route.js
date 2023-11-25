const express = require('express');
const categoryController = require('../controller/category.controller');

const router = express.Router();

router.get('/getAll', categoryController.getAllCategories);

module.exports = router;