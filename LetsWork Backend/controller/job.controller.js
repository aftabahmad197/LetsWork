const jobService = require('../services/job.services');

exports.addJob = async (req, res) => {
    try {
      const { title, description, category, buyer, budget, deadline, } = req.body;
  
      const savedJob = await jobService.addJob({
        title,
        description,
        category,
        buyer,
        budget,
        deadline,
      });
  
      res.status(201).json(savedJob);
    } catch (error) {
      console.error('Error in job controller:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

exports.getAllJobs = async (req, res) => {
  try {
    const jobs = await jobService.getAllJobs();
    res.json(jobs);
  } catch (error) {
    console.error('Error getting all jobs:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.getAllJobsByBuyer = async (req, res) => {
  try {
    const buyerEmail = req.params.buyer;
    const jobs = await jobService.getAllJobsByBuyer(buyerEmail);
    res.json(jobs);
  } catch (error) {
    console.error('Error getting all jobs by buyer:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.editJob = async (req, res) => {
  try {
    const editedJob = await jobService.editJob(req.params.id, req.body);
    res.json(editedJob);
  } catch (error) {
    console.error('Error editing job:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.deleteJob = async (req, res) => {
  try {
    const deletedJob = await jobService.deleteJob(req.params.id);
    res.json(deletedJob);
  } catch (error) {
    console.error('Error deleting job:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.getAllJobsExceptSeller = async (req, res) => {
  try {
    const sellerEmail = req.params.seller;
    const jobs = await jobService.getAllJobsExceptSeller(sellerEmail);
    res.json(jobs);
  } catch (error) {
    console.error('Error getting all jobs except seller:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.addSellerToJob = async (req, res) => {
  try {
    const jobId = req.params.id;
    const sellerEmail = req.body.seller;
    const updatedJob = await jobService.addSellerToJob(jobId, sellerEmail);
    res.json(updatedJob);
  } catch (error) {
    console.error('Error adding seller to job:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.getAllJobsWhereSeller = async (req, res) => {
  try {
    const jobs = await jobService.getAllJobsWhereSeller(req.params.Buyer);
    res.json(jobs);
  } catch (error) {
    console.error('Error getting all jobs where seller:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}