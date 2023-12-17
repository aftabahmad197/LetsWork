const express = require('express');
const gigController = require('../controller/gig.controller');

const router = express.Router();

router.post('/add', gigController.addGig);
router.get('/getAll', gigController.getAllGigs);
router.get('/getAllExceptBuyer/:buyer', gigController.getAllExceptBuyer);
router.get('/getallgigswherebuyer/:seller', gigController.getAllGigsWhereBuyer);
router.get('/getallgigs/:seller', gigController.getAllGigsBySeller);
router.put('/edit/:id', gigController.editGig);
router.delete('/delete/:id', gigController.deleteGig);
router.patch('/addBuyertoGig', gigController.addBuyertoGig);


module.exports = router;