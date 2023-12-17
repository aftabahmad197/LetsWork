const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
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
  buyer: {
    type: String,
    required: true,
  },
  Seller: {
    type: String,
    default: "",
  },
  budget: {
    type: Number,
    required: true,
  },
  deadline: {
    type: Date,
    required: true,
  },
  attachments: {
    type: [String],
  },
},
{
  timestamps: true,
});

// Middleware to format the deadline before saving to the database
jobSchema.pre('save', function (next) {
    if (this.deadline && typeof this.deadline === 'string') {
      // Assuming the date string is in the format "DD/MM/YYYY"
      const [day, month, year] = this.deadline.split('/');
      this.deadline = new Date(`${month}/${day}/${year}`);
    }
    next();
  });

const Job = mongoose.model('Job', jobSchema);

module.exports = Job;
