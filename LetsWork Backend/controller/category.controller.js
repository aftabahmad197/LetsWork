const categoryService = require('../services/category.services');

exports.getAllCategories = async (req, res) => {
  try {
    const categories = await categoryService.getAll();

    // Flatten the data to include both categories and subcategories
    const flattenedCategories = categories.reduce((acc, category) => {
      // Add the main category
      acc.push({ _id: category._id, name: category.name, type: 'category' });

      // Add subcategories
      category.subcategories.forEach(subcategory => {
        acc.push({ _id: subcategory._id, name: subcategory.name, type: 'subcategory' });
      });

      return acc;
    }, []);

    res.json(flattenedCategories);
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};