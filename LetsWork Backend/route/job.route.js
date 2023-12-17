const express = require('express');
const jobController = require('../controller/job.controller');

const router = express.Router();

router.post('/add', jobController.addJob);
router.get('/getAll', jobController.getAllJobs);
router.get('/getalljobs/:buyer', jobController.getAllJobsByBuyer);
router.get('/getalljobsExceptSeller/:seller', jobController.getAllJobsExceptSeller);
router.get('/getAllwhereSeller/:Buyer', jobController.getAllJobsWhereSeller);
router.put('/edit/:id', jobController.editJob);
router.delete('/delete/:id', jobController.deleteJob);
router.patch('/addSellertojob/:id', jobController.addSellerToJob);

module.exports = router;