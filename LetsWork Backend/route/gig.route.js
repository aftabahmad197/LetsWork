const express = require('express');
const gigController = require('../controller/gig.controller');

const router = express.Router();

router.post('/add', gigController.addGig);
router.get('/getAll', gigController.getAllGigs);
router.get('/getallgigs/:seller', gigController.getAllGigsBySeller);
router.put('/edit/:id', gigController.editGig);
router.delete('/delete/:id', gigController.deleteGig);


module.exports = router;