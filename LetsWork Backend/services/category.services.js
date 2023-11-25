
const { categoryModel } = require("../model/category.model");

async function getAll() {
  try {
    const categories = await categoryModel.find();
    return categories;
  } catch (error) {
    throw new Error(error.message);
  }
}

module.exports = {
  getAll,
};