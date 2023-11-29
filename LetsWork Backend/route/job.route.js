const express = require('express');
const jobController = require('../controller/job.controller');

const router = express.Router();

router.post('/add', jobController.addJob);
router.get('/getAll', jobController.getAllJobs);
router.get('/getalljobs/:buyer', jobController.getAllJobsByBuyer);
router.put('/edit/:id', jobController.editJob);
router.delete('/delete/:id', jobController.deleteJob);

module.exports = router;