const jobModel = require('../model/job.model');

const addJob = async ({ title, description, category, buyer, budget, deadline }) => {
    try {
      // Validate and parse the deadline string
      const parsedDeadline = new Date(deadline);
  
      // Check if the parsedDeadline is a valid date
      if (isNaN(parsedDeadline.getTime())) {
        throw new Error('Invalid deadline date format');
      }
  
      const newJob = new jobModel({
        title,
        description,
        category,
        buyer,
        budget,
        deadline: parsedDeadline,
      });
  
      const savedJob = await newJob.save();
      return savedJob;
    } catch (error) {
      console.error('Error adding job to database:', error);
      throw error;
    }
  };
  

async function getAllJobs() {
  try {
    return await jobModel.find().populate('category buyer');
  } catch (error) {
    console.error('Error getting all jobs from database:', error);
    throw error;
  }
}

async function getAllJobsByBuyer(buyer) {
  try {
    var jobs = await jobModel.find({ buyer });
    if (!jobs) throw new Error("No jobs found");
    return jobs;
  } catch (error) {
    console.error('Error getting all jobs from database:', error);
    throw error;
  }
}

async function getAllJobsWhereSeller(seller) {
  try {
    var jobs = await jobModel.find({
      $and: [
        { Seller: { $ne: '' } }, // Seller is not equal to ""
        { buyer: buyer },        // buyer is equal to the specified buyer
      ]
    });
    if (!jobs) throw new Error("No jobs found");
    return jobs;
  } catch (error) {
    console.error('Error getting all jobs from database:', error);
    throw error;
  }
}
async function getAllJobsExceptSeller(seller) {
  try {
    var jobs = await jobModel.find({ Seller: { $ne: seller } }) || await jobModel.find({ Seller:  '' });
    if (!jobs) throw new Error("No jobs found");
    return jobs;
  } catch (error) {
    console.error('Error getting all jobs from database:', error);
    throw error;
  }
}

async function editJob(jobId, updatedJobData) {
  try {
    return await jobModel.findByIdAndUpdate(jobId, updatedJobData, { new: true });
  } catch (error) {
    console.error('Error updating job in database:', error);
    throw error;
  }
}

async function deleteJob(jobId) {
  try {
    return await jobModel.findByIdAndDelete(jobId);
  } catch (error) {
    console.error('Error deleting job from database:', error);
    throw error;
  }
}

async function addSellerToJob(jobId, sellerEmail) {
  try {
    job = await jobModel.findById(jobId);
    if (!job) throw new Error("No job found");
    const updateData = { Seller: sellerEmail };
    return await jobModel.findByIdAndUpdate(jobId, updateData, { new: true });
  } catch (error) {
    console.error('Error adding seller to job in database:', error);
    throw error;
  }
}

module.exports = {
  addJob,
  getAllJobs,
  editJob,
  getAllJobsByBuyer,
  deleteJob,
  getAllJobsExceptSeller,
  addSellerToJob,
  getAllJobsWhereSeller
};
