const gigService = require('../services/gig.services');

exports.addGig = async (req, res) => {
  try {
    const gig = await gigService.addGig(req.body);
    res.json(gig);
  } catch (error) {
    console.error('Error adding gig:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.getAllGigs = async (req, res) => {
  try {
    const gigs = await gigService.getAllGigs();
    res.json(gigs);
  } catch (error) {
    console.error('Error getting all gigs:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.getAllGigsBySeller = async (req, res) => {
  try {
    const sellerEmail = req.params.seller;
    const gigs = await gigService.getAllGigsBySeller(sellerEmail);
    res.json(gigs);
  } catch (error) {
    console.error('Error getting all gigs by seller:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.editGig = async (req, res) => {
  try {
    const editedGig = await gigService.editGig(req.params.id, req.body);
    res.json(editedGig);
  } catch (error) {
    console.error('Error editing gig:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.deleteGig = async (req, res) => {
  try {
    const deletedGig = await gigService.deleteGig(req.params.id);
    res.json(deletedGig);
  } catch (error) {
    console.error('Error deleting gig:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
