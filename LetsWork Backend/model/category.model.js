const mongoose = require('mongoose');

// Define the FreelanceCategory schema
const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
  },
  description: {
    type: String,
    required: true,
  },
  subcategories: [{
    name: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
  }],
},
{
    timestamps: true,
  }
);

// Create the FreelanceCategory model
const categoryModel = mongoose.model('category', categorySchema);

// Create a function to initialize hard-coded data
async function initializeData() {
  try {
    // Check if data already exists
    const existingData = await categoryModel.find();
    if (existingData.length === 0) {
      // Hard-coded data
      const categories = [
        {
          name: 'Web Development',
          description: 'Building websites and web applications',
          subcategories: [
            {
              name: 'Frontend Development',
              description: 'Designing and implementing user interfaces',
            },
            {
              name: 'Backend Development',
              description: 'Server-side logic and databases',
            },
          ],
        },
        {
          name: 'Graphic Design',
          description: 'Creating visual content for various purposes',
          subcategories: [
            {
              name: 'Logo Design',
              description: 'Crafting unique and memorable logos',
            },
            {
              name: 'UI/UX Design',
              description: 'Improving user experience and interface design',
            },
          ],
        },
        // Add more categories as needed
      ];

      // Insert data into the database
      await categoryModel.insertMany(categories);

      console.log('Hard-coded data initialized successfully.');
    } else {
      console.log('Data already exists. Skipping initialization.');
    }
  } catch (error) {
    console.error('Error initializing data:', error);
  }
}

// Export the model and data initialization function
module.exports = {
    categoryModel,
  initializeData,
};