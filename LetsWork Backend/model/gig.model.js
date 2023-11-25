const mongoose = require('mongoose');
const gigSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  seller: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  deliveryTime: {
    type: Number,
    required: true,
  },
  image: {
    type: String,
  },
},
{
    timestamps: true,
  }
);

const Gig = mongoose.model('Gig', gigSchema);

module.exports = Gig;
