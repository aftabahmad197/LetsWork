const express = require('express');
const gigController = require('../controller/gig.controller');

const router = express.Router();

router.post('/add', gigController.addGig);
router.get('/getAll', gigController.getAllGigs);
router.get('/getallgig/:seller', gigController.getAllGigsBySeller);
router.put('/edit/:id', gigController.editGig);

module.exports = router;