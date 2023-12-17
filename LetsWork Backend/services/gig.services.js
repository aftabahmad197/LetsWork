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

async function getAllExceptBuyer(buyeremail) {
  try {
    var gigs = await gigModel.find({ buyer: { $ne: buyeremail } });
    if(!gigs) throw new Error("No gigs found");
    return gigs;
  } catch (error) {
    console.error('Error getting all gigs from database:', error);
    throw error;
  }
}

async function getAllGigsWhereBuyer(seller) {
  try {
    var gigs = await gigModel.find({
      $and: [
        { buyer: { $ne: '' } }, // Seller is not equal to ""
        { seller: seller },        // buyer is equal to the specified buyer
      ]
    });
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

async function deleteGig(gigId) {
  try {
    return await gigModel.findByIdAndDelete(gigId);
  } catch (error) {
    console.error('Error deleting gig from database:', error);
    throw error;
  }
}

async function addBuyertoGig(gigID, buyer) {
  try {
    gig = await gigModel.findById(gigID);
    if (!gig) throw new Error("No gig found");
    const updateData = { buyer: buyer };
    return await gigModel.findByIdAndUpdate(gigID, updateData, { new: true });
  }
  catch (error) {
    console.error('Error updating gig in database:', error);
    throw error;
  }
}

module.exports = {
  addGig,
  getAllGigs,
  editGig,
  getAllGigsBySeller,
  deleteGig,
  addBuyertoGig,
  getAllExceptBuyer,
  getAllGigsWhereBuyer
};
