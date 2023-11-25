const gigModel = require('../model/gig.model');
async function addGig(gigData) {
  try {
    const gig = new gigModel(gigData);
    return await gig.save();
  } catch (error) {
    console.error('Error adding gig to database:', error);
    throw error;
  }
}
async function getAllGigs() {
  try {
    return await gigModel.find().populate('category seller');
  } catch (error) {
    console.error('Error getting all gigs from database:', error);
    throw error;
  }
}

async function getAllGigsBySeller(seller) {
  try {
    var gigs = await gigModel.find({ seller});
    if(!gigs) throw new Error("No gigs found");
    return gigs;
  } catch (error) {
    console.error('Error getting all gigs from database:', error);
    throw error;
  }
}

async function editGig(gigId, updatedGigData) {
  try {
    return await gigModel.findByIdAndUpdate(gigId, updatedGigData, { new: true });
  } catch (error) {
    console.error('Error updating gig in database:', error);
    throw error;
  }
}

module.exports = {
  addGig,
  getAllGigs,
  editGig,
  getAllGigsBySeller
};
